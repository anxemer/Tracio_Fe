import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import '../route/route_processor.dart';
import '../route/kalman_filter.dart';
import '../route/stop_detector.dart';
import '../route/jump_detector.dart';
import 'location_service_handler.dart';

class TrackingDataModel {
  final LocationData position;
  final double speedKmH;
  final double bearing;
  final double odometer; // meters
  final double altitude;
  final Duration totalDuration;
  final Duration movingTime;
  final Duration stopTime;
  final double elevationGain;
  final RouteDiagnostics? routeDiagnostics;
  final List<Waypoint>? waypoints;
  final bool isStationary;
  final double speedAccuracy;
  final double positionAccuracy;
  final double maxSpeed;
  final double currentSpeed;
  final double elevationAccuracy;

  const TrackingDataModel({
    required this.position,
    required this.speedKmH,
    required this.bearing,
    required this.odometer,
    required this.altitude,
    required this.totalDuration,
    required this.movingTime,
    required this.stopTime,
    required this.elevationGain,
    this.routeDiagnostics,
    this.waypoints,
    this.isStationary = false,
    this.speedAccuracy = 0.0,
    this.positionAccuracy = 0.0,
    this.maxSpeed = 0.0,
    this.currentSpeed = 0.0,
    this.elevationAccuracy = 0.0,
  });
}

class Waypoint {
  final LatLng position;
  final DateTime timestamp;
  final String? label;
  final Map<String, dynamic>? metadata;

  const Waypoint({
    required this.position,
    required this.timestamp,
    this.label,
    this.metadata,
  });
}

class LocationService {
  late Location _location;

  DateTime? _startTime;
  DateTime? _lastMovingTime;
  Duration _movingTime = Duration.zero;
  final double _movementThreshold = 0.5;

  LocationData? _lastPosition;
  double _elevationGain = 0.0;
  double _totalDistance = 0.0;
  final _recentSpeeds = <double>[];

  final _dataController = StreamController<TrackingDataModel>.broadcast();
  StreamSubscription<LocationData>? _positionSubscription;

  bool _isDisposed = false;
  bool _isPaused = false;

  // Enhanced filtering components
  final RouteProcessor _routeProcessor;
  final PositionKalmanFilter _kalmanFilter;
  final StopDetector _stopDetector;
  final JumpDetector _jumpDetector;

  // Enhanced filtering parameters
  static const double _stationarySpeedThreshold = 0.1; // m/s
  static const double _stationaryAccuracyThreshold =
      15.0; // meters (increased to match typical GPS accuracy)
  static const int _stationaryTimeThreshold = 3; // seconds
  static const double _speedAccuracyThreshold =
      2.0; // m/s (increased to match typical speed accuracy)
  static const int _speedWindowSize = 3;
  static const double _bearingSmoothingFactor = 0.2;
  static const double _adaptiveSmoothingMinFactor = 0.1;
  static const double _adaptiveSmoothingMaxFactor = 0.4;

  // New fields for enhanced tracking
  final List<Waypoint> _waypoints = [];
  final List<double> _recentBearings = [];
  final List<double> _recentAccuracies = [];
  DateTime? _lastStationaryCheck;
  bool _isStationary = false;
  int _stationaryCount = 0;
  final _speedWeights = [0.1, 0.15, 0.2, 0.25, 0.3]; // Weighted moving average

  LocationService()
      : _routeProcessor = RouteProcessor(
          smoothingFactor: 0.2,
          updateInterval: 2,
          minPointsForUpdate: 3,
          douglasPeuckerEpsilon: 0.00003,
          enableElevationFiltering: true,
        ),
        _kalmanFilter = PositionKalmanFilter(
          processNoise: 0.1,
          measurementNoise: 0.1,
          adaptiveNoise: true,
        ),
        _stopDetector = StopDetector(
          debounceTime: Duration(seconds: 2),
          speedThreshold: 0.5,
        ),
        _jumpDetector = JumpDetector(
          maxSpeedJump: 20.0,
          maxDistanceJump: 50.0,
        );

  Duration get duration =>
      DateTime.now().difference(_startTime ?? DateTime.now());

  Duration get movingTime => _movingTime;

  Duration get stoppingTime => duration - movingTime;

  bool get isPaused => _isPaused;

  bool get isTracking =>
      !_isDisposed && !_isPaused && _positionSubscription != null;

  double get smoothedSpeed {
    if (_recentSpeeds.isEmpty) return 0;
    return _recentSpeeds.reduce((a, b) => a + b) / _recentSpeeds.length * 3.6;
  }

  Stream<TrackingDataModel> get trackingDataStream => _dataController.stream;

  Future<void> _requestPlatformPermissions() async {
    // Android 13+, you need to allow notification permission to display foreground service notification.
    // iOS: If you need notification, ask for permission.
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }

    if (Platform.isAndroid) {
      // Android 12+, there are restrictions on starting a foreground service.
      if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
      }

      // For long-term survival services
      if (!await FlutterForegroundTask.canScheduleExactAlarms) {
        await FlutterForegroundTask.openAlarmsAndRemindersSettings();
      }
    }
  }

  Future<void> _requestLocationPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services is disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Location permission has been ${permission.name}.');
    }
  }

  Future<void> initialize() async {
    try {
      _location = Location();

      // Request platform-specific permissions first
      await _requestPlatformPermissions();
      // Then request location permissions
      await _requestLocationPermission();

      // Configure location settings
      await _location.changeSettings(
        interval: 1000, // 1 second
        distanceFilter: 0, // meters
      );
    } catch (e) {
      debugPrint('Error initializing location service: $e');
      rethrow;
    }
  }

  Future<void> _initializeForegroundTask() async {
    // Initialize foreground task
    FlutterForegroundTask.initCommunicationPort();
    FlutterForegroundTask.addTaskDataCallback((data) {
      if (data is String) {
        try {
          var totalDuration =
              DateTime.now().difference(_startTime ?? DateTime.now());
          FlutterForegroundTask.updateService(
            notificationTitle: 'Recording...',
            notificationText:
                'Duration: ${_formatDuration(totalDuration)}  Distance: ${(_totalDistance / 1000).toStringAsFixed(2)} km',
          );
          _handlePosition(jsonDecode(data));
        } catch (e) {
          debugPrint('Error processing location data: $e');
        }
      }
    });
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'tracio_location_service',
        channelName: 'TracioLocation Service',
        channelDescription: 'This notification is used for location tracking.',
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> startTracking({
    bool forceLocationManager = false,
  }) async {
    if (_positionSubscription != null) return;

    try {
      _isDisposed = false;

      // Initialize foreground task only when starting tracking
      await _initializeForegroundTask();
      await initialize();

      // Start foreground service with all available options
      await FlutterForegroundTask.startService(
        serviceId: 1,
        notificationTitle: 'Tracio Location Service',
        notificationText: 'Tracking your location...',
        notificationIcon: NotificationIcon(
          metaDataName: 'notification_icon',
        ),
        notificationButtons: [
          NotificationButton(
            id: 'pause_button',
            text: 'Pause',
          ),
        ],
        callback: startLocationService,
      );

      // Initialize location stream with error handling
      _positionSubscription = _location.onLocationChanged.listen(
        _handlePosition,
        onError: (error) {
          debugPrint('Error in location stream: $error');
          // Attempt to restart the stream if it fails
          if (!_isDisposed && !_isPaused) {
            startTracking();
          }
        },
      );
    } catch (e) {
      debugPrint('Error starting location tracking: $e');
      throw Exception('Failed to start location tracking service: $e');
    }
  }

  Future<LocationData?> getCurrentLocation() async {
    final pos = await _location.getLocation();
    _handlePosition(pos);
    return pos;
  }

  double _calculateAdaptiveSmoothingFactor(double speed) {
    // Reduce smoothing at higher speeds for better turn detection
    return _adaptiveSmoothingMaxFactor -
        (speed *
            (_adaptiveSmoothingMaxFactor - _adaptiveSmoothingMinFactor) /
            20.0);
  }

  double _smoothBearing(double bearing) {
    _recentBearings.add(bearing);
    if (_recentBearings.length > 3) {
      _recentBearings.removeAt(0);
    }

    // Use exponential smoothing with _bearingSmoothingFactor
    double smoothedBearing = _recentBearings[0];
    for (int i = 1; i < _recentBearings.length; i++) {
      smoothedBearing = smoothedBearing * (1 - _bearingSmoothingFactor) +
          _recentBearings[i] * _bearingSmoothingFactor;
    }
    return smoothedBearing;
  }

  double _calculateWeightedSpeed() {
    if (_recentSpeeds.isEmpty) return 0;

    double weightedSum = 0;
    double weightSum = 0;

    for (int i = 0; i < _recentSpeeds.length; i++) {
      final weight = _speedWeights[i];
      weightedSum += _recentSpeeds[i] * weight;
      weightSum += weight;
    }

    return weightedSum / weightSum * 3.6; // Convert to km/h
  }

  bool _checkStationary(LocationData position, double speed) {
    final now = DateTime.now();
    if (_lastStationaryCheck == null) {
      _lastStationaryCheck = now;

      return false;
    }

    final timeSinceLastCheck = now.difference(_lastStationaryCheck!).inSeconds;
    if (timeSinceLastCheck < 1) {
      return _isStationary;
    }

    _lastStationaryCheck = now;
    _recentAccuracies.add(position.accuracy!);
    if (_recentAccuracies.length > 5) {
      _recentAccuracies.removeAt(0);
    }

    final avgAccuracy =
        _recentAccuracies.reduce((a, b) => a + b) / _recentAccuracies.length;

    // Convert speed to m/s if it's in km/h
    final speedInMs = speed > 10 ? speed / 3.6 : speed;

    // More realistic conditions for stationary detection
    if (speedInMs < _stationarySpeedThreshold &&
        avgAccuracy < _stationaryAccuracyThreshold &&
        position.speedAccuracy! < _speedAccuracyThreshold) {
      _stationaryCount++;
    } else {
      // Only reset count if speed is significantly above threshold
      if (speedInMs > _stationarySpeedThreshold * 2) {
        _stationaryCount = 0;
      }
    }

    _isStationary = _stationaryCount >= _stationaryTimeThreshold;
    return _isStationary;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  void _handlePosition(LocationData newPos) {
    if (_isDisposed || _isPaused) return;

    final now = DateTime.now();
    _startTime ??= now;

    // Add speed to recent speeds list
    _recentSpeeds.add(newPos.speed!);
    if (_recentSpeeds.length > _speedWindowSize) {
      _recentSpeeds.removeAt(0);
    }

    // Check if stationary before processing
    final isStationary = _checkStationary(newPos, newPos.speed!);

    if (isStationary) {
      // If stationary, only update time and emit minimal data
      if (_lastMovingTime != null) {
        _movingTime += now.difference(_lastMovingTime!);
        _lastMovingTime = null;
      }

      // Store the last non-stationary position
      final lastNonStationaryPosition = _lastPosition ?? newPos;

      final data = TrackingDataModel(
        position: lastNonStationaryPosition, // Use last non-stationary position
        speedKmH: 0.0,
        bearing: lastNonStationaryPosition.heading!,
        odometer: _totalDistance,
        altitude: lastNonStationaryPosition.altitude!,
        totalDuration: now.difference(_startTime!),
        movingTime: _movingTime,
        stopTime: now.difference(_startTime!) - _movingTime,
        elevationGain: _elevationGain,
        isStationary: true,
        speedAccuracy: newPos.speedAccuracy!,
        positionAccuracy: newPos.accuracy!,
        elevationAccuracy: newPos.verticalAccuracy!,
      );
      _dataController.add(data);
      return;
    }

    // Convert LocationData to LatLng for processing
    final latLng = LatLng(newPos.latitude!, newPos.longitude!);

    // Calculate adaptive smoothing factor based on speed
    final smoothingFactor = _calculateAdaptiveSmoothingFactor(newPos.speed!);

    // Apply Kalman filter with adaptive parameters and smoothing factor
    final filteredPosition = _kalmanFilter.filterPosition(
      latLng,
      newPos.speed!,
      newPos.heading!,
      now,
      smoothingFactor: smoothingFactor,
    );

    // Filter elevation
    final filteredElevation =
        _kalmanFilter.filterElevation(newPos.altitude!, now);

    // Update Kalman filter noise parameters
    _kalmanFilter.updateNoiseParameters(newPos.speed!, filteredElevation);

    // Smooth bearing using the bearing smoothing factor
    final smoothedBearing = _smoothBearing(newPos.heading!);

    // Check for GPS jumps
    if (_jumpDetector.isJump(filteredPosition, newPos.speed!, now)) {
      return;
    }

    // Process the point through RouteProcessor
    final chunk = _routeProcessor.processPoint(
      filteredPosition,
      newPos.speed!,
      smoothedBearing,
      now,
      elevation: filteredElevation,
    );

    // Calculate distance using filtered position
    if (_lastPosition != null) {
      final delta = Geolocator.distanceBetween(
        _lastPosition!.latitude!,
        _lastPosition!.longitude!,
        filteredPosition.latitude,
        filteredPosition.longitude,
      );
      _totalDistance += delta;
    }

    // Update moving time
    if (newPos.speed! >= _movementThreshold) {
      _lastMovingTime ??= now;
    } else {
      if (_lastMovingTime != null) {
        _movingTime += now.difference(_lastMovingTime!);
        _lastMovingTime = null;
      }
    }

    // Update elevation gain
    if (_lastPosition != null) {
      final altDiff = filteredElevation - _lastPosition!.altitude!;
      if (altDiff > 0 && altDiff < 50) {
        _elevationGain += altDiff;
      }
    }

    _lastPosition = newPos;

    // Finalize durations and emit
    final totalDuration = now.difference(_startTime!);
    final stopTime = totalDuration - _movingTime;

    final data = TrackingDataModel(
      position: newPos,
      speedKmH: _calculateWeightedSpeed(),
      bearing: smoothedBearing,
      odometer: _totalDistance,
      altitude: filteredElevation,
      totalDuration: totalDuration,
      movingTime: _movingTime,
      stopTime: stopTime,
      elevationGain: _elevationGain,
      routeDiagnostics: chunk?.diagnostics,
      maxSpeed: _stopDetector.maxSpeed * 3.6, // Convert to km/h
      currentSpeed: newPos.speed! * 3.6,
      speedAccuracy: newPos.speedAccuracy!,
      positionAccuracy: newPos.accuracy!,
      elevationAccuracy: newPos.verticalAccuracy!,
      isStationary: false,
      waypoints:
          _waypoints.isEmpty ? null : List<Waypoint>.unmodifiable(_waypoints),
    );

    _dataController.add(data);
  }

  void pause() {
    _isPaused = true;

    // Finalize moving time if active
    if (_lastMovingTime != null) {
      _movingTime += DateTime.now().difference(_lastMovingTime!);
      _lastMovingTime = null;
    }

    // Cancel the stream to stop receiving updates
    _positionSubscription?.cancel();
    _positionSubscription = null;

    // Update notification to show paused state
    FlutterForegroundTask.updateService(
      notificationText: 'Paused - Tap to resume',
      notificationButtons: [
        NotificationButton(
          id: 'resume_button',
          text: 'Resume',
        ),
      ],
    );
  }

  Future<void> resume({int distanceFilter = 1}) async {
    if (!_isPaused) return;

    _isPaused = false;

    // Restart the position stream
    _positionSubscription = _location.onLocationChanged.listen(_handlePosition);

    // Optionally reset moving time
    if (_lastPosition?.speed != null &&
        _lastPosition!.speed! >= _movementThreshold) {
      _lastMovingTime = DateTime.now();
    }

    // Update notification to show tracking state
    FlutterForegroundTask.updateService(
      notificationText: 'Tracking...',
      notificationButtons: [
        NotificationButton(
          id: 'pause_button',
          text: 'Pause',
        ),
      ],
    );
  }

  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _isPaused = false;
    _isDisposed = true;

    // Stop foreground service
    try {
      await FlutterForegroundTask.stopService();
    } catch (e) {
      debugPrint('Error stopping foreground service: $e');
    }
  }

  void reset() {
    _totalDistance = 0.0;
    _lastPosition = null;
    _recentSpeeds.clear();
    _recentBearings.clear();
    _recentAccuracies.clear();
    _startTime = null;
    _movingTime = Duration.zero;
    _lastMovingTime = null;
    _elevationGain = 0.0;
    _stationaryCount = 0;
    _isStationary = false;
    _lastStationaryCheck = null;
    _waypoints.clear();
    _routeProcessor.reset();
    _kalmanFilter.reset();
    _stopDetector.reset();
    _jumpDetector.reset();
  }

  void dispose() {
    _isDisposed = true;
    _positionSubscription?.cancel();
    _dataController.close();
  }

  // Add waypoint
  void addWaypoint(LatLng position,
      {String? label, Map<String, dynamic>? metadata}) {
    _waypoints.add(Waypoint(
      position: position,
      timestamp: DateTime.now(),
      label: label,
      metadata: metadata,
    ));
  }

  // Remove waypoint
  void removeWaypoint(int index) {
    if (index >= 0 && index < _waypoints.length) {
      _waypoints.removeAt(index);
    }
  }

  // Clear all waypoints
  void clearWaypoints() {
    _waypoints.clear();
  }
}
