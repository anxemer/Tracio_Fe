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

class AddMatchedUser extends TrackingEvent {
  final MatchedUserEntity user;

  const AddMatchedUser(this.user);

  @override
  List<Object?> get props => [user];
}

class RemoveMatchedUser extends TrackingEvent {
  final int userId;

  const RemoveMatchedUser(this.userId);

  @override
  List<Object?> get props => [userId];
}
