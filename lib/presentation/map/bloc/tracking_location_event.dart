import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

abstract class LocationEvent {}

class StartLocationTracking extends LocationEvent {}

class UpdateLocation extends LocationEvent {
  final bg.Location position;
  final double heading;
  UpdateLocation(this.position, this.heading);
}

class StopLocationTracking extends LocationEvent {}

class PauseLocationTracking extends LocationEvent {}

class PauseTrackingDueToStandstill extends LocationEvent {}

class UserHeadingChanged extends LocationEvent {
  final double heading;
  UserHeadingChanged(this.heading);
}

class UserMovedSignificantly extends LocationEvent {
  final bg.Location position;
  UserMovedSignificantly(this.position);
}

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationTracking extends LocationState {}

class LocationUpdated extends LocationState {
  final bg.Location position;
  final double heading;
  LocationUpdated(this.position, this.heading);
}

class LocationPaused extends LocationState {}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
