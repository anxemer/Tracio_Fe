part of 'tracking_bloc.dart';

sealed class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object?> get props => [];
}

class StartTracking extends TrackingEvent {
  final int? routeId;
  final int? groupRouteId;

  const StartTracking({this.routeId, this.groupRouteId});

  @override
  List<Object?> get props => [routeId, groupRouteId];
}

class PauseTracking extends TrackingEvent {}
class ResumeTracking extends TrackingEvent {}
class EndTracking extends TrackingEvent {}
class UpdateTime extends TrackingEvent {}
class UpdateTrackingData extends TrackingEvent {
  final bg.Location location;

  const UpdateTrackingData(this.location);

  @override
  List<Object?> get props => [location];
}
