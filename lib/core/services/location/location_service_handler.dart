import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
void startLocationService() {
  FlutterForegroundTask.setTaskHandler(LocationServiceHandler());
}

class LocationServiceHandler extends TaskHandler {
  StreamSubscription<LocationData>? _streamSubscription;
  final Location _location = Location();
  bool _isPaused = false;

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

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    try {
      debugPrint('LocationServiceHandler: Starting location service...');
      _requestLocationPermission();
      // Start location stream
      debugPrint('LocationServiceHandler: Initializing location stream...');
      _location.changeSettings(
        distanceFilter: 0,
        interval: 2000,
      );
      _streamSubscription = _location.onLocationChanged.listen(
        (location) {
          debugPrint(
              'LocationServiceHandler: Received location update - lat: ${location.latitude}, lon: ${location.longitude}');
          if (_isPaused) {
            debugPrint(
                'LocationServiceHandler: Service is paused, ignoring location update');
            return;
          }
          // Send data to main isolate
          final String locationJson = jsonEncode(location.toString());
          debugPrint('LocationServiceHandler: Sending data to main isolate');
          FlutterForegroundTask.sendDataToMain(locationJson);
        },
        onError: (error) {
          debugPrint(
              'LocationServiceHandler: Error in location stream: $error');
          // Attempt to restart the stream if it fails
          if (!_isPaused) {
            debugPrint(
                'LocationServiceHandler: Attempting to restart location stream...');
            onStart(timestamp, starter);
          }
        },
      );
      debugPrint(
          'LocationServiceHandler: Location stream initialized successfully');
    } catch (e) {
      debugPrint('LocationServiceHandler: Error starting location service: $e');
      rethrow;
    }
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    debugPrint('LocationServiceHandler: onRepeatEvent called at $timestamp');
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isDestroyed) async {
    debugPrint('LocationServiceHandler: Destroying location service...');
    _streamSubscription?.cancel();
    _streamSubscription = null;
    debugPrint('LocationServiceHandler: Location service destroyed');
  }

  @override
  void onNotificationButtonPressed(String id) {
    debugPrint('LocationServiceHandler: Notification button pressed: $id');
    if (id == 'pause_button') {
      _isPaused = true;
      debugPrint('LocationServiceHandler: Service paused');
      FlutterForegroundTask.updateService(
        notificationText: 'Paused - Tap to resume',
        notificationButtons: [
          NotificationButton(
            id: 'resume_button',
            text: 'Resume',
          ),
        ],
      );
    } else if (id == 'resume_button') {
      _isPaused = false;
      debugPrint('LocationServiceHandler: Service resumed');
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
  }
}
