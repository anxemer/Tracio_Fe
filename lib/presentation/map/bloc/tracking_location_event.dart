import 'package:geolocator/geolocator.dart';

abstract class LocationEvent {}

class StartLocationTracking extends LocationEvent {}

class UpdateLocation extends LocationEvent {
  final Position position;
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
  final Position position;
  UserMovedSignificantly(this.position);
}

abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationUpdated extends LocationState {
  final Position position;
  final double heading;
  LocationUpdated(this.position, this.heading);
}

class LocationPaused extends LocationState {}

class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}
