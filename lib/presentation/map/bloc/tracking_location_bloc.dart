import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'tracking_location_event.dart';

class LocationCubit extends Cubit<LocationState> {
  DateTime? _startTime;
  DateTime? _lastUpdateTime;
  Duration _movingTime = Duration.zero;
  double _totalElevationGain = 0.0;
  double _lastAltitude = 0.0;

  LocationCubit() : super(LocationInitial());

  void updateLocation(bg.Location location, double heading) {
    int tmpRouteId = 0;
    int tmpGroupRouteId = 0;
    if (state is LocationInitial) {
      var s = state as LocationInitial;
      tmpGroupRouteId = s.groupRouteId!;
      tmpRouteId = s.routeId ?? 0;
    }
    final now = DateTime.parse(location.timestamp);
    _startTime ??= now;
    final duration = now.difference(_startTime!);

    if (_lastUpdateTime != null && location.isMoving) {
      final deltaTime = now.difference(_lastUpdateTime!);
      _movingTime += deltaTime;
    }

    final currentAltitude = location.coords.altitude;
    final deltaAltitude = currentAltitude - _lastAltitude;
    if (deltaAltitude > 0) {
      _totalElevationGain += deltaAltitude;
    }
    _lastAltitude = currentAltitude;

    final odometerKm = location.odometer / 1000;
    final avgSpeed = _movingTime.inSeconds > 0
        ? (odometerKm / _movingTime.inSeconds) * 3600
        : 0.0;

    _lastUpdateTime = now;

    emit(LocationUpdated(
      position: location,
      altitude: currentAltitude,
      speed: location.coords.speed,
      odometerKm: odometerKm,
      timestamp: now,
      heading: heading,
      elevationGain: _totalElevationGain,
      movingTime: _movingTime,
      duration: duration,
      avgSpeed: avgSpeed,
      routeId: tmpRouteId,
      groupRouteId: tmpGroupRouteId,
    ));
  }

  void updateRouteId(int routeId) {
    if (state is LocationInitial) {
      final currentState = state as LocationInitial;
      emit(currentState.copyWith(routeId: routeId));
    }
  }

  void updateGroupRouteId(int groupRouteId) {
    if (state is LocationInitial) {
      final currentState = state as LocationInitial;
      emit(currentState.copyWith(groupRouteId: groupRouteId));
    }
  }

  void pauseTracking() {
    emit(LocationPaused());
  }

  void stopTracking() {
    _startTime = null;
    _lastUpdateTime = null;
    _movingTime = Duration.zero;
    _totalElevationGain = 0.0;
    _lastAltitude = 0.0;

    emit(LocationInitial());
  }
}
