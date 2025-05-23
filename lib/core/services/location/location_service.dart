import 'dart:async';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class TrackingDataModel {
  final Position position;
  final double speedKmH;
  final double bearing;
  final double odometer; // meters
  final double altitude;
  final Duration totalDuration;
  final Duration movingTime;
  final Duration stopTime;
  final double elevationGain;

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
  });
}

class LocationService {
  DateTime? _startTime;
  DateTime? _lastMovingTime;
  Duration _movingTime = Duration.zero;
  final double _movementThreshold = 0.5;

  Position? _lastPosition;
  double _elevationGain = 0.0;
  double _totalDistance = 0.0;
  final _recentSpeeds = <double>[];

  final _dataController = StreamController<TrackingDataModel>.broadcast();
  StreamSubscription<Position>? _positionSubscription;

  bool _isDisposed = false;
  bool _isPaused = false;
  bool _forceLocationManager = false;
  int _currentDistanceFilter = -1;

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

  Future<bool> initialize() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }

    return true;
  }

  Future<void> startTracking({
    bool forceLocationManager = false,
  }) async {
    if (_positionSubscription != null) return;

    _forceLocationManager = forceLocationManager;

    final initialized = await initialize();
    if (!initialized) return;

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: _setLocationSettings(),
    ).listen(_handlePosition);
  }

  Future<Position?> getCurrentLocation() async {
    final pos = await Geolocator.getCurrentPosition();
    _handlePosition(pos);
    return pos;
  }

  void _handlePosition(Position newPos) {
    if (_isDisposed || _isPaused) return;

    final now = DateTime.now();
    _startTime ??= now;

    // 1️⃣ Calculate distance
    if (_lastPosition != null) {
      final delta = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        newPos.latitude,
        newPos.longitude,
      );
      _totalDistance += delta;
    }

    // 2️⃣ Calculate smoothed speed
    _addSmoothedSpeed(newPos.speed);
    final speedKmh = newPos.speed * 3.6;

    // 3️⃣ Throttle filter adjustment
    EasyThrottle.throttle(
      'distance-filter-throttle',
      const Duration(seconds: 10),
      () => _adjustDistanceFilter(speedKmh),
    );

    // 4️⃣ Update moving or stopping time
    if (newPos.speed >= _movementThreshold) {
      _lastMovingTime ??= now;
    } else {
      if (_lastMovingTime != null) {
        _movingTime += now.difference(_lastMovingTime!);
        _lastMovingTime = null;
      }
    }

    // 5️⃣ Elevation gain calculation
    if (_lastPosition != null) {
      final altDiff = newPos.altitude - _lastPosition!.altitude;
      if (altDiff > 0 && altDiff < 50) {
        _elevationGain += altDiff;
      }
    }

    _lastPosition = newPos;

    // 6️⃣ Finalize durations and emit
    final totalDuration = now.difference(_startTime!);
    final stopTime = totalDuration - _movingTime;

    final data = TrackingDataModel(
      position: newPos,
      speedKmH: smoothedSpeed,
      bearing: newPos.heading,
      odometer: _totalDistance,
      altitude: newPos.altitude,
      totalDuration: totalDuration,
      movingTime: _movingTime,
      stopTime: stopTime,
      elevationGain: _elevationGain,
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
    EasyThrottle.cancel('distance-filter-throttle');
  }

  Future<void> resume({int distanceFilter = 1}) async {
    if (!_isPaused) return;

    _isPaused = false;

    // Restart the position stream
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: _setLocationSettings(),
    ).listen(_handlePosition);

    // Optionally reset moving time
    if (_lastPosition?.speed != null &&
        _lastPosition!.speed >= _movementThreshold) {
      _lastMovingTime = DateTime.now();
    }
  }

  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _isPaused = false;
    _isDisposed = true;
    EasyThrottle.cancel('distance-filter-throttle');
  }

  /// 🚲 Maintain sliding window of last 5 speeds
  void _addSmoothedSpeed(double speed) {
    _recentSpeeds.add(speed);
    if (_recentSpeeds.length > 5) {
      _recentSpeeds.removeAt(0);
    }
  }

  void reset() {
    _totalDistance = 0.0;
    _lastPosition = null;
    _recentSpeeds.clear();
    _startTime = null;
    _movingTime = Duration.zero;
    _lastMovingTime = null;
  }

  LocationSettings _setLocationSettings() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
        forceLocationManager: _forceLocationManager,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "Tracio will continue to receive your location even when you aren't using it",
          notificationTitle: "Running in Background",
          enableWakeLock: true,
        ),
        useMSLAltitude: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else if (kIsWeb) {
      return WebSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
        maximumAge: Duration(minutes: 5),
      );
    } else {
      return LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      );
    }
  }

  Future<void> _adjustDistanceFilter(double speedKmh) async {
    if (_isDisposed || _isPaused) return;
    final newDistance = calculateAdaptiveDistanceFilter(speedKmh);
    if (_currentDistanceFilter == newDistance) return;

    _currentDistanceFilter = newDistance;
    await _positionSubscription?.cancel();

    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: newDistance,
        forceLocationManager: _forceLocationManager,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: "Tracio",
          notificationText: "Adjusting tracking precision...",
          enableWakeLock: true,
        ),
      ),
    ).listen(_handlePosition);
  }

  int calculateAdaptiveDistanceFilter(double speedKmh) {
    if (speedKmh < 5) {
      return 3; // walking or idle
    } else if (speedKmh < 15) {
      return 5; // jogging
    } else if (speedKmh < 30) {
      return 7; // cycling
    } else {
      return 9; // driving/motorbike
    }
  }

  void dispose() {
    _isDisposed = true;
    _positionSubscription?.cancel();
    _dataController.close();
    EasyThrottle.cancel('distance-filter-throttle');
  }
}
