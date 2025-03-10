import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'tracking_location_event.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<Position>? _positionSubscription;
  Position? _lastPosition;
  double _lastHeading = 0;
  final double movementThreshold = 2.0; // Meters to detect standstill

  LocationBloc() : super(LocationInitial()) {
    on<StartLocationTracking>(_onStartTracking);
    on<UpdateLocation>(_onUpdateLocation);
    on<PauseTrackingDueToStandstill>(_onPauseTracking);
    on<UserHeadingChanged>(_onUserHeadingChanged);
    on<UserMovedSignificantly>(_onUserMovedSignificantly);
    on<StopLocationTracking>(_onStopTracking);
  }

  void _onStartTracking(
      StartLocationTracking event, Emitter<LocationState> emit) {
    _startLocationUpdates(emit);
  }

  void _onUpdateLocation(UpdateLocation event, Emitter<LocationState> emit) {
    // Check if user is standing still
    if (_lastPosition != null) {
      double distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        event.position.latitude,
        event.position.longitude,
      );

      if (distance < movementThreshold) {
        add(PauseTrackingDueToStandstill());
        return;
      }
    }

    // Check if user changed heading significantly
    if ((_lastHeading - event.heading).abs() > 10) {
      add(UserHeadingChanged(event.heading));
    }

    _lastPosition = event.position;
    _lastHeading = event.heading;

    emit(LocationUpdated(event.position, event.heading));
  }

  void _onPauseTracking(
      PauseTrackingDueToStandstill event, Emitter<LocationState> emit) {
    _positionSubscription?.pause();
    emit(LocationPaused());
  }

  void _onUserHeadingChanged(
      UserHeadingChanged event, Emitter<LocationState> emit) {
    emit(LocationUpdated(_lastPosition!, event.heading));
  }

  void _onUserMovedSignificantly(
      UserMovedSignificantly event, Emitter<LocationState> emit) {
    emit(LocationUpdated(event.position, _lastHeading));
  }

  void _onStopTracking(
      StopLocationTracking event, Emitter<LocationState> emit) {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    emit(LocationInitial());
  }

  void _startLocationUpdates(Emitter<LocationState> emit) {
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position position) {
        add(UpdateLocation(position, position.heading));
      },
      onError: (error) {
        emit(LocationError("Location tracking error: $error"));
      },
    );
  }

  @override
  Future<void> close() {
    _positionSubscription?.cancel();
    return super.close();
  }
}
