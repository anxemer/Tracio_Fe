part of 'tracking_bloc.dart';

sealed class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

final class TrackingInitial extends TrackingState {}

final class TrackingInProgress extends TrackingState {
  final bool isPaused;
  final List<LatLng> polyline;
  final bg.Location? position;
  final double? speed;
  final double? odometerKm;
  final double? altitude;
  final double? elevationGain;
  final Duration duration;
  final Duration movingTime;
  final double? avgSpeed;
  final double? battery;
  final DateTime currentTime;
  final int? routeId;
  final int? groupRouteId;
  final List<MatchedUserEntity>? matchedUsers;

  const TrackingInProgress({
    required this.isPaused,
    required this.polyline,
    required this.duration,
    required this.movingTime,
    this.position,
    this.speed,
    this.odometerKm,
    this.altitude,
    this.elevationGain,
    this.avgSpeed,
    this.battery,
    required this.currentTime,
    this.routeId,
    this.groupRouteId,
    this.matchedUsers,
  });

  TrackingInProgress copyWith({
    bool? isPaused,
    List<LatLng>? polyline,
    bg.Location? position,
    double? speed,
    double? odometerKm,
    double? altitude,
    double? elevationGain,
    Duration? duration,
    Duration? movingTime,
    double? avgSpeed,
    double? battery,
    DateTime? currentTime,
    int? routeId,
    int? groupRouteId,
    List<MatchedUserEntity>? matchedUsers,
  }) {
    return TrackingInProgress(
      isPaused: isPaused ?? this.isPaused,
      polyline: polyline ?? this.polyline,
      position: position ?? this.position,
      speed: speed ?? this.speed,
      odometerKm: odometerKm ?? this.odometerKm,
      altitude: altitude ?? this.altitude,
      elevationGain: elevationGain ?? this.elevationGain,
      duration: duration ?? this.duration,
      movingTime: movingTime ?? this.movingTime,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      battery: battery ?? this.battery,
      currentTime: currentTime ?? this.currentTime,
      routeId: routeId ?? this.routeId,
      groupRouteId: groupRouteId ?? this.groupRouteId,
      matchedUsers: matchedUsers ?? this.matchedUsers,
    );
  }

  @override
  List<Object?> get props => [
        isPaused,
        polyline,
        position,
        speed,
        odometerKm,
        altitude,
        elevationGain,
        duration,
        movingTime,
        avgSpeed,
        battery,
        currentTime,
        routeId,
        groupRouteId,
        matchedUsers,
      ];
}
