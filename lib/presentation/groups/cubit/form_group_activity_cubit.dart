import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracio_fe/data/groups/models/request/post_group_route_req.dart';
import 'package:tracio_fe/domain/groups/usecases/post_group_route_usecase.dart';
import 'package:tracio_fe/presentation/groups/cubit/form_group_activity_state.dart';
import 'package:tracio_fe/service_locator.dart';

class FormGroupActivityCubit extends Cubit<FormGroupActivityState> {
  FormGroupActivityCubit()
      : super(
          FormGroupActivityUpdate(
            activityName: '',
            description: '',
            meetingAddress: '',
            meetingLocation: null,
            startDateTime: DateTime.now(),
            routeId: -1,
          ),
        );

  void initForm({
    String activityName = '',
    String description = '',
    String meetingAddress = '',
    required Position? meetingLocation,
    required DateTime startDateTime,
    int routeId = -1,
  }) {
    emit(state.copyWith(
      activityName: activityName,
      description: description,
      meetingAddress: meetingAddress,
      meetingLocation: meetingLocation,
      startDateTime: startDateTime,
      routeId: routeId,
    ));
  }

  void updateActivityName(String activityName) {
    emit(state.copyWith(activityName: activityName));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateMeetingAddress(String meetingAddress) {
    emit(state.copyWith(meetingAddress: meetingAddress));
  }

  void updateMeetingLocation(Position position) {
    emit(state.copyWith(meetingLocation: position));
  }

  void updateStartDateTime(DateTime start) {
    emit(state.copyWith(startDateTime: start));
  }

  void updateRouteId(int routeId) {
    emit(state.copyWith(routeId: routeId));
  }

  void reset() {
    emit(
      FormGroupActivityUpdate(
        activityName: '',
        description: '',
        meetingAddress: '',
        meetingLocation: null,
        startDateTime: DateTime.now(),
        routeId: -1,
      ),
    );
  }

  PostGroupRouteReq toPostGroupRouteRequest() {
    final current = state;

    if (current.meetingLocation == null) {
      throw Exception('Meeting location is required.');
    }

    return PostGroupRouteReq(
      routeId: current.routeId,
      title: current.activityName,
      description: current.description,
      addressMeeting: current.meetingAddress,
      startTime: current.startDateTime,
      address: current.meetingLocation!,
    );
  }

  Future<void> submitCreateGroupActivity(int groupId) async {
    emit(state.copyWith(isLoading: true));

    var request = toPostGroupRouteRequest();
    final result = await sl<PostGroupRouteUsecase>()
        .call(PostGroupRouteParams(groupId: groupId, request: request));

    result.fold((error) {
      emit(state.copyWith(
          isLoading: false, isFailed: true, errorMessage: error.message));
    }, (data) {
      emit(state.copyWith(isSuccess: true, isLoading: false));
    });
  }
}
