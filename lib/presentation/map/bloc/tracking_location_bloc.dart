import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'tracking_location_event.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  bg.Location? _lastPosition;
  double _lastHeading = 0;
  Timer? _debounceTimer;
  bool _isConfigured = false;

  LocationBloc() : super(LocationInitial()) {
    on<StartLocationTracking>(_onStartTracking);
    on<UpdateLocation>(_onUpdateLocation);
    on<PauseTrackingDueToStandstill>(_onPauseTrackingDueToStandstill);
    on<PauseLocationTracking>(_onPauseTracking);
    on<StopLocationTracking>(_onStopTracking);
  }
//TODO Debounce the location updates to prevent frequent updates
  void _onStartTracking(
      StartLocationTracking event, Emitter<LocationState> emit) {
    if (!_isConfigured) {
      _configureBackgroundLocation(); // ✅ Now only runs when StartLocationTracking is called
      _isConfigured = true;
    }
    bg.BackgroundGeolocation.start();
    emit(LocationTracking());
  }

  void _configureBackgroundLocation() {
    bg.BackgroundGeolocation.onLocation((bg.Location location) async {
      await Future.delayed(Duration(milliseconds: 10));
      bg.BackgroundGeolocation.setConfig(bg.Config(
          notification: bg.Notification(
        title: "Location tracking",
        text: "${location.coords.latitude}, ${location.coords.longitude}",
      )));
      add(UpdateLocation(location, location.coords.heading));
    });

    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      if (!location.isMoving) {
        add(PauseTrackingDueToStandstill());
      } else {
        bg.BackgroundGeolocation.changePace(true); // ✅ Resume tracking
      }
    });

    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      if (!event.enabled) {
        print("GPS Provider disabled! Restarting tracking...");
        bg.BackgroundGeolocation.start();
      }
    });

    bg.BackgroundGeolocation.ready(bg.Config(
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 5.0, // Update location every 5 meters
      stopOnTerminate: false,
      foregroundService: true,
      logLevel: bg.Config.LOG_LEVEL_INFO,
    )).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });
  }

  void _onUpdateLocation(UpdateLocation event, Emitter<LocationState> emit) {
    _lastPosition = event.position;
    _lastHeading = event.heading;
    emit(LocationUpdated(event.position, event.heading));
  }

  void _onPauseTracking(
      PauseLocationTracking event, Emitter<LocationState> emit) {
    bg.BackgroundGeolocation.changePace(
        false); // ✅ Pause updates when not moving
    emit(LocationPaused());
  }

  void _onPauseTrackingDueToStandstill(
      PauseTrackingDueToStandstill event, Emitter<LocationState> emit) {
    bg.BackgroundGeolocation.changePace(
        false); // ✅ Pause updates when not moving
    emit(LocationPaused());
  }

  void _onStopTracking(
      StopLocationTracking event, Emitter<LocationState> emit) {
    bg.BackgroundGeolocation.stop();
    bg.BackgroundGeolocation.destroyLocations();
    _debounceTimer?.cancel();
    emit(LocationInitial());
  }

  @override
  Future<void> close() {
    bg.BackgroundGeolocation.stop();
    _debounceTimer?.cancel();
    return super.close();
  }
}
