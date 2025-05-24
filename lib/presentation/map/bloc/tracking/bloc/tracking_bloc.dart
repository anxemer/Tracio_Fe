import 'dart:async';

import 'package:Tracio/core/services/location/location_service.dart';
import 'package:Tracio/core/services/signalR/implement/group_route_hub_service.dart';
import 'package:Tracio/core/services/signalR/implement/matching_hub_service.dart';
import 'package:Tracio/data/map/models/request/finish_tracking_req.dart';
import 'package:Tracio/domain/map/entities/matched_user.dart';
import 'package:Tracio/domain/map/entities/route_detail.dart';
import 'package:Tracio/domain/map/usecase/finish_tracking_usecase.dart';
import 'package:Tracio/domain/map/usecase/start_tracking_usecase.dart';
import 'package:Tracio/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final LocationService _locationService;

  DateTime? _startTime;
  DateTime? _movingStartTime;
  double _totalElevationGain = 0;
  Timer? _ticker;
  Duration _totalMovingTime = Duration.zero;
  StreamSubscription? _locationStream;

  TrackingBloc(this._locationService) : super(TrackingInitial()) {
    on<StartTracking>(_onStartTracking);
    on<PauseTracking>(_onPauseTracking);
    on<EndTracking>(_onEndTracking);
    on<UpdateTrackingData>(_onUpdateTrackingData);
    on<ResumeTracking>(_onResumeTracking);
    on<UpdateTime>(_onUpdateTime);
    on<AddMatchedUser>(_onAddMatchedUser);
    on<RemoveMatchedUser>(_onRemoveMatchedUser);
    on<RequestStartTracking>(_onRequestStartTracking);
    on<RequestFinishTracking>(_onRequestFinishTracking);
  }

  void _onStartTracking(
      StartTracking event, Emitter<TrackingState> emit) async {
    _startTime = DateTime.now();
    _movingStartTime = DateTime.now();
    _totalElevationGain = 0;
    _totalMovingTime = Duration.zero;

    await _locationService.startTracking();

    _locationStream = _locationService.trackingDataStream.listen((data) {
      add(UpdateTrackingData(data));
    });

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
    _locationService.pause();
    _ticker?.cancel();
    if (state is TrackingInProgress) {
      emit((state as TrackingInProgress).copyWith(isPaused: true));
    }
  }

  void _onEndTracking(EndTracking event, Emitter<TrackingState> emit) async {
    await _locationStream?.cancel();
    await _locationService.stopTracking();
    _ticker?.cancel();
    emit(TrackingInitial());
  }

  void _onResumeTracking(
      ResumeTracking event, Emitter<TrackingState> emit) async {
    await _locationService.resume();
    _movingStartTime = DateTime.now();

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      add(UpdateTime());
    });

    if (state is TrackingInProgress) {
      emit((state as TrackingInProgress).copyWith(isPaused: false));
    }
  }

  void _onUpdateTrackingData(
      UpdateTrackingData event, Emitter<TrackingState> emit) {
    if (state is! TrackingInProgress) return;
    final currentState = state as TrackingInProgress;
    if (currentState.isPaused) return;

    final data = event.trackingData;

    final updatedPolyline = List<LatLng>.from(currentState.polyline)
      ..add(LatLng(data.position.latitude, data.position.longitude));
    if (updatedPolyline.length > 1000) {
      updatedPolyline.removeAt(0);
    }

    emit(currentState.copyWith(
      polyline: updatedPolyline,
      position: data.position,
      speed: data.speedKmH,
      odometerKm: data.odometer / 1000,
      altitude: data.altitude,
      elevationGain: data.elevationGain,
      duration: data.totalDuration,
      movingTime: data.movingTime,
      avgSpeed: data.speedKmH,
      currentTime: DateTime.now(),
    ));
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

  void _onAddMatchedUser(AddMatchedUser event, Emitter<TrackingState> emit) {
    final currentState = state;
    if (currentState is TrackingInProgress) {
      final updatedList = [...?currentState.matchedUsers];

      if (!updatedList.any((u) => u.userId == event.user.userId)) {
        updatedList.add(event.user);
      }

      emit(currentState.copyWith(matchedUsers: updatedList));
    }
  }

  void _onRemoveMatchedUser(
      RemoveMatchedUser event, Emitter<TrackingState> emit) {
    final currentState = state;
    if (currentState is TrackingInProgress) {
      final updatedList = [...?currentState.matchedUsers]
          .where((u) => u.userId != event.userId)
          .toList();

      emit(currentState.copyWith(matchedUsers: updatedList));
    }
  }

  Future<void> _onRequestStartTracking(
      RequestStartTracking event, Emitter<TrackingState> emit) async {
    try {
      final initialized = await _locationService.initialize();
      if (!initialized) {
        emit(const TrackingError(
            "Location permission not granted or service disabled."));
        return;
      }
      final origin = await _locationService.getCurrentLocation();
      if (origin == null) {
        emit(const TrackingError("Failed to get current location."));
        return;
      }

      Map<String, dynamic> params = {
        'origin': {
          "latitude": origin.latitude,
          "longitude": origin.longitude,
          "altitude": origin.altitude,
        },
      };

      final joinedGroupRoutes = sl<GroupRouteHubService>().joinedGroupRouteIds;
      if (joinedGroupRoutes.isNotEmpty) {
        params["groupRouteId"] = joinedGroupRoutes.first;
      }
      emit(TrackingStarting());
      final result = await sl<StartTrackingUsecase>().call(params);

      result.fold(
        (error) {
          emit(TrackingError("Failed to start tracking: ${error.message}"));
        },
        (response) async {
          final routeIdFromApi = response["result"]["routeId"];
          add(StartTracking(routeId: routeIdFromApi));
          await sl<MatchingHubService>().connect();
          debugPrint("✅ Tracking started: $response");
        },
      );
    } catch (e) {
      emit(TrackingError("Unexpected error starting tracking: $e"));
    }
  }

  Future<void> _onRequestFinishTracking(
      RequestFinishTracking event, Emitter<TrackingState> emit) async {
    final trackingState = state;

    if (trackingState is! TrackingInProgress || trackingState.routeId == null) {
      emit(const TrackingError("Not tracking or missing routeId."));
      return;
    }

    emit(TrackingFinishing());
    final result = await sl<FinishTrackingUsecase>().call(
      FinishTrackingReq(routeId: trackingState.routeId!),
    );

    result.fold((error) {
      emit(TrackingError(error.message));
      add(EndTracking()); // optional: cleanup
    }, (response) {
      if (response == null) {
        emit(const TrackingError("Route too short to save (under 500m)."));
        add(EndTracking());
        return;
      }

      // emit route detail success
      emit(TrackingFinished(response));
    });
  }
}
