import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationTracking extends LocationState {}

class LocationUpdated extends LocationState {
  final bg.Location position;
  final double altitude;
  final double heading;
  final double speed;
  final double odometerKm;
  final double elevationGain;
  final Duration movingTime;
  final Duration duration;
  final double avgSpeed;
  final DateTime timestamp;

  LocationUpdated({
    required this.position,
    required this.heading,
    required this.elevationGain,
    required this.movingTime,
    required this.duration,
    required this.avgSpeed,
  })  : speed = position.coords.speed * 3.6,
        odometerKm = position.odometer / 1000,
        altitude = position.coords.altitude,
        timestamp = DateTime.parse(position.timestamp);
}

class LocationPaused extends LocationState {}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
