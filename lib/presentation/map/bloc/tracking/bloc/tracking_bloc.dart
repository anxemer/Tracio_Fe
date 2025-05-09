import 'dart:async';

import 'package:equatable/equatable.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  DateTime? _startTime;
  DateTime? _movingStartTime;
  double _totalElevationGain = 0;
  Timer? _ticker;
  Duration _totalMovingTime = Duration.zero;

  TrackingBloc() : super(TrackingInitial()) {
    on<StartTracking>(_onStartTracking);
    on<PauseTracking>(_onPauseTracking);
    on<EndTracking>(_onEndTracking);
    on<UpdateTrackingData>(_onUpdateTrackingData);
    on<ResumeTracking>(_onResumeTracking);
    on<UpdateTime>(_onUpdateTime);
  }

  void _onStartTracking(StartTracking event, Emitter<TrackingState> emit) {
    _startTime = DateTime.now();
    _movingStartTime = DateTime.now();
    _totalElevationGain = 0;
    _totalMovingTime = Duration.zero;
    _movingStartTime = DateTime.now();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      add(UpdateTime());
    });
    emit(TrackingInProgress(
      isPaused: false,
      polyline: [],
      position: null,
      speed: 0,
      odometerKm: 0,
      altitude: 0,
      elevationGain: 0,
      duration: Duration.zero,
      movingTime: Duration.zero,
      avgSpeed: 0,
      currentTime: DateTime.now(),
      battery: null,
      routeId: event.routeId,
      groupRouteId: event.groupRouteId,
    ));
  }

  void _onPauseTracking(PauseTracking event, Emitter<TrackingState> emit) {
    if (state case TrackingInProgress s) {
      if (_movingStartTime != null) {
        _totalMovingTime += DateTime.now().difference(_movingStartTime!);
      }
      emit(s.copyWith(isPaused: true));
    }
  }

  void _onEndTracking(EndTracking event, Emitter<TrackingState> emit) {
    _ticker?.cancel();
    emit(TrackingInitial());
  }

  void _onResumeTracking(ResumeTracking event, Emitter<TrackingState> emit) {
    if (state is TrackingInProgress) {
      final currentState = state as TrackingInProgress;
      if (currentState.isPaused) {
        _movingStartTime = DateTime.now();
        emit(currentState.copyWith(isPaused: false));
      }
    }
  }

  void _onUpdateTrackingData(
      UpdateTrackingData event, Emitter<TrackingState> emit) {
    if (state is! TrackingInProgress) return;
    final currentState = state as TrackingInProgress;
    if (currentState.isPaused) return;

    final now = DateTime.now();
    final location = event.location;
    final latLng = LatLng(location.coords.latitude, location.coords.longitude);

    final updatedPolyline = List<LatLng>.from(currentState.polyline)
      ..add(latLng);
    const maxPoints = 1000;
    if (updatedPolyline.length > maxPoints) {
      updatedPolyline.removeAt(0);
    }

    final odometerKm = (location.odometer) / 1000;
    final duration = now.difference(_startTime!);
    final movingTime = now.difference(_movingStartTime!);
    final speed = location.coords.speed * 18 / 5;
    final altitude = location.coords.altitude;

    if (currentState.altitude != null && altitude > currentState.altitude!) {
      _totalElevationGain += (altitude - currentState.altitude!);
    }

    final avgSpeed =
        (duration.inSeconds > 0) ? odometerKm / (duration.inSeconds / 3600) : 0;

    final batteryLevel = location.battery.level * 100;

    emit(currentState.copyWith(
        position: location,
        polyline: updatedPolyline,
        altitude: altitude,
        speed: speed,
        odometerKm: odometerKm,
        elevationGain: _totalElevationGain,
        movingTime: movingTime,
        duration: duration,
        avgSpeed: avgSpeed.toDouble(),
        battery: batteryLevel));
  }

  void _onUpdateTime(UpdateTime event, Emitter<TrackingState> emit) {
    if (state is! TrackingInProgress) return;
    final currentState = state as TrackingInProgress;
    if (currentState.isPaused) return;

    final now = DateTime.now();
    final duration = now.difference(_startTime!);
    final movingTime = _totalMovingTime + (now.difference(_movingStartTime!));

    emit(currentState.copyWith(
      duration: duration,
      movingTime: movingTime,
      currentTime: now,
    ));
  }
}
