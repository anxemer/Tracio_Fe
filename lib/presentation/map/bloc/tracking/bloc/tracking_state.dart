part of 'tracking_bloc.dart';

sealed class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

final class TrackingInitial extends TrackingState {
  final int? groupRouteId;

  const TrackingInitial({this.groupRouteId});

  @override
  List<Object?> get props => [groupRouteId];
}

final class TrackingInProgress extends TrackingState {
  final bool isPaused;
  final List<LatLng> polyline;
  final LocationData? position;
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
  final List<Participant>? groupParticipants;

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
    this.groupParticipants,
  });

  TrackingInProgress copyWith({
    bool? isPaused,
    List<LatLng>? polyline,
    LocationData? position,
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
    List<Participant>? groupParticipants,
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
      groupParticipants: groupParticipants ?? this.groupParticipants,
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
        groupParticipants,
      ];
}

final class TrackingFinished extends TrackingState {
  final RouteDetailEntity route;

  const TrackingFinished(this.route);

  @override
  List<Object?> get props => [route];
}

final class TrackingError extends TrackingState {
  final String message;

  const TrackingError(this.message);

  @override
  List<Object?> get props => [message];
}

final class TrackingStarting extends TrackingState {}

final class TrackingFinishing extends TrackingState {}
