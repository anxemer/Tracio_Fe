// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

abstract class LocationState {}

class LocationInitial extends LocationState {
  final int? routeId;
  final int? groupRouteId;
  LocationInitial({
    this.routeId,
    this.groupRouteId,
  });

  LocationInitial copyWith({
    int? routeId,
    int? groupRouteId,
  }) {
    return LocationInitial(
      routeId: routeId ?? this.routeId,
      groupRouteId: groupRouteId ?? this.groupRouteId,
    );
  }
}

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
  final int? routeId;
  final int? groupRouteId;

  LocationUpdated({
    required this.position,
    required this.heading,
    required this.altitude,
    required this.speed,
    required this.odometerKm,
    required this.elevationGain,
    required this.timestamp,
    required this.movingTime,
    required this.duration,
    required this.avgSpeed,
    this.routeId,
    this.groupRouteId,
  });

  LocationUpdated copyWith({
    bg.Location? position,
    double? altitude,
    double? heading,
    double? speed,
    double? odometerKm,
    double? elevationGain,
    Duration? movingTime,
    Duration? duration,
    double? avgSpeed,
    DateTime? timestamp,
    int? routeId,
    int? groupRouteId,
  }) {
    return LocationUpdated(
      position: position ?? this.position,
      altitude: altitude ?? this.altitude,
      heading: heading ?? this.heading,
      speed: speed ?? this.speed,
      odometerKm: odometerKm ?? this.odometerKm,
      elevationGain: elevationGain ?? this.elevationGain,
      movingTime: movingTime ?? this.movingTime,
      duration: duration ?? this.duration,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      timestamp: timestamp ?? this.timestamp,
      routeId: routeId ?? this.routeId,
      groupRouteId: groupRouteId ?? this.groupRouteId,
    );
  }
}

class LocationPaused extends LocationState {}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
