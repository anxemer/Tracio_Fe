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

import 'package:location/location.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:battery_plus/battery_plus.dart';
part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final LocationService _locationService;
  final Battery _battery = Battery();

  DateTime? _startTime;
  DateTime? _movingStartTime;
  double _totalElevationGain = 0;
  Timer? _ticker;
  Duration _totalMovingTime = Duration.zero;
  StreamSubscription? _locationStream;
  int? _groupRouteId;

  int? get groupRouteId => _groupRouteId;

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
    on<ResetTracking>(_onResetTracking);
    on<AddGroupRouteId>(_onAddGroupRouteId);
    on<AddGroupParticipant>(_onAddGroupParticipant);
    on<RemoveGroupParticipant>(_onRemoveGroupParticipant);
    on<LeaveGroupRoute>(_onLeaveGroupRoute);
  }

  Future<double?> _getBatteryLevel() async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      return batteryLevel.toDouble();
    } catch (e) {
      debugPrint('Error getting battery level: $e');
      return null;
    }
  }

  void _onStartTracking(
      StartTracking event, Emitter<TrackingState> emit) async {
    // Ensure any existing tracking is cleaned up first
    await _locationStream?.cancel();
    _locationStream = null;
    _ticker?.cancel();
    _ticker = null;

    // Reset state variables
    _startTime = DateTime.now();
    _movingStartTime = DateTime.now();
    _totalElevationGain = 0;
    _totalMovingTime = Duration.zero;

    await _locationService.startTracking();

    _locationStream = _locationService.trackingDataStream.listen((data) {
      add(UpdateTrackingData(data));
    });

    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      add(UpdateTime());
    });

    // Get initial battery level
    final batteryLevel = await _getBatteryLevel();

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
      battery: batteryLevel,
      routeId: event.routeId,
      groupRouteId: event.groupRouteId,
      matchedUsers: [],
      groupParticipants: [],
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
    // Cancel all subscriptions and timers
    await _locationStream?.cancel();
    _locationStream = null;
    _ticker?.cancel();
    _ticker = null;

    // Stop location service
    await _locationService.stopTracking();

    // Reset all state variables
    _startTime = null;
    _movingStartTime = null;
    _totalElevationGain = 0;
    _totalMovingTime = Duration.zero;

    // Reset location service
    _locationService.reset();

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
      UpdateTrackingData event, Emitter<TrackingState> emit) async {
    if (state is! TrackingInProgress) return;
    final currentState = state as TrackingInProgress;
    if (currentState.isPaused) return;

    final data = event.trackingData;

    // If stationary, only update time and other metrics, but not position
    if (data.isStationary) {
      // Update battery level periodically
      double? batteryLevel = currentState.battery;
      if (DateTime.now().difference(currentState.currentTime).inMinutes >= 5) {
        batteryLevel = await _getBatteryLevel();
      }

      emit(currentState.copyWith(
        speed: 0.0, // Set speed to 0 when stationary
        duration: data.totalDuration,
        movingTime: data.movingTime,
        currentTime: DateTime.now(),
        battery: batteryLevel, // Fix battery percentage calculation
      ));
      return;
    }

    // Calculate elevation gain
    if (data.altitude > 0 && currentState.altitude != null) {
      final elevationChange = data.altitude - currentState.altitude!;
      if (elevationChange > 0) {
        _totalElevationGain += elevationChange;
      }
    }

    final updatedPolyline = List<LatLng>.from(currentState.polyline)
      ..add(LatLng(data.position.latitude!, data.position.longitude!));

    // Update battery level periodically
    double? batteryLevel = currentState.battery;
    if (DateTime.now().difference(currentState.currentTime).inMinutes >= 5) {
      batteryLevel = await _getBatteryLevel();
    }

    emit(currentState.copyWith(
      polyline: updatedPolyline,
      position: data.position,
      speed: data.speedKmH,
      odometerKm: data.odometer / 1000,
      altitude: data.altitude,
      elevationGain: _totalElevationGain,
      duration: data.totalDuration,
      movingTime: data.movingTime,
      avgSpeed: data.speedKmH,
      currentTime: DateTime.now(),
      battery: batteryLevel,
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
      await _locationService.initialize();

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

      // Add groupRouteId to params if available
      if (_groupRouteId != null) {
        params["groupRouteId"] = _groupRouteId;
      }

      emit(TrackingStarting());
      final result = await sl<StartTrackingUsecase>().call(params);

      result.fold(
        (error) {
          emit(TrackingError(error.message));
        },
        (response) async {
          final routeIdFromApi = response["result"]["routeId"];
          add(StartTracking(
            routeId: routeIdFromApi,
            groupRouteId: _groupRouteId,
          ));
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
      add(EndTracking()); // Ensure cleanup happens
    }, (response) async {
      if (response == null) {
        emit(const TrackingError("Route too short to save (under 500m)."));
        add(EndTracking()); // Ensure cleanup happens
        return;
      }
      emit(TrackingFinished(response));
      // Add EndTracking after a short delay to ensure state is properly cleaned up
      await Future.delayed(const Duration(milliseconds: 100));
      add(EndTracking());
    });
  }

  void _onResetTracking(ResetTracking event, Emitter<TrackingState> emit) {
    // Cancel all subscriptions and timers
    _locationStream?.cancel();
    _locationStream = null;
    _ticker?.cancel();
    _ticker = null;

    // Reset all state variables
    _startTime = null;
    _movingStartTime = null;
    _totalElevationGain = 0;
    _totalMovingTime = Duration.zero;

    // Reset location service
    _locationService.reset();

    emit(TrackingInitial());
  }

  void _onAddGroupRouteId(AddGroupRouteId event, Emitter<TrackingState> emit) {
    _groupRouteId = event.groupRouteId;
    final currentState = state;
    if (currentState is TrackingInProgress) {
      emit(currentState.copyWith(groupRouteId: event.groupRouteId));
    } else if (currentState is TrackingInitial) {
      emit(TrackingInitial(groupRouteId: event.groupRouteId));
    }
  }

  void _onAddGroupParticipant(
      AddGroupParticipant event, Emitter<TrackingState> emit) {
    final currentState = state;
    if (currentState is TrackingInProgress) {
      final updatedList = [...?currentState.groupParticipants];

      if (!updatedList.any((p) => p.userId == event.participant.userId)) {
        updatedList.add(event.participant);
      }

      emit(currentState.copyWith(groupParticipants: updatedList));
    }
  }

  void _onRemoveGroupParticipant(
      RemoveGroupParticipant event, Emitter<TrackingState> emit) {
    final currentState = state;
    if (currentState is TrackingInProgress) {
      final updatedList = [...?currentState.groupParticipants]
          .where((p) => p.userId != event.userId)
          .toList();

      emit(currentState.copyWith(groupParticipants: updatedList));
    }
  }

  Future<void> _onLeaveGroupRoute(
      LeaveGroupRoute event, Emitter<TrackingState> emit) async {
    final currentState = state;
    if (currentState is TrackingInProgress &&
        currentState.groupRouteId != null) {
      try {
        final groupRouteHub = sl<GroupRouteHubService>();
        await groupRouteHub
            .leaveGroupRoute(currentState.groupRouteId.toString());

        emit(currentState.copyWith(
          groupRouteId: null,
          groupParticipants: null,
        ));
      } catch (e) {
        debugPrint('Error leaving group route: $e');
      }
    }
  }
}
