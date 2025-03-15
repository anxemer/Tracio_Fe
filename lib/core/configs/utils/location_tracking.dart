import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationTracking {
  StreamSubscription<Position>? userPositionStream;
  Future<StreamSubscription<Position>?> setupPositionTracking() async {
    await checkAndRequestPermissions();

    userPositionStream?.cancel();
    return userPositionStream;
  }

  Future<Stream<Position>> startTracking() async {
    await checkAndRequestPermissions();
    return Geolocator.getPositionStream(locationSettings: _setLocationSettings());
  }

  /// Checks and requests necessary location permissions.
  ///
  Future<void> checkAndRequestPermissions() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
    throw Exception('Location permissions are permanently denied. Please enable them in settings.');
}

    if (permission == LocationPermission.denied) {
      throw Exception('Location permissions are denied.');
    }
  }

  /// Stops location tracking.
  void stopTracking() {
    userPositionStream?.cancel();
    userPositionStream = null;
  }

  LocationSettings _setLocationSettings() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 5),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
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
}
