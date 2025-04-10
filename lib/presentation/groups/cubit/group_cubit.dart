import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/core/constants/membership_enum.dart';
import 'package:tracio_fe/data/groups/models/request/get_group_list_req.dart';
import 'package:tracio_fe/data/groups/models/request/post_group_req.dart';
import 'package:tracio_fe/data/groups/models/request/post_group_route_req.dart';
import 'package:tracio_fe/domain/groups/usecases/get_group_detail_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/get_group_list_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/get_group_route_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/get_participant_list_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/leave_group_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/post_group_route_usecase.dart';
import 'package:tracio_fe/domain/groups/usecases/post_group_usecase.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';
import 'package:tracio_fe/service_locator.dart';

class GroupCubit extends Cubit<GroupState> {
  GroupCubit() : super(GroupInitial());

  void refreshState() {
    emit(GroupInitial());
  }

  Future<void> postGroup(PostGroupReq request) async {
    emit(GroupLoading());
    var data = await sl<PostGroupUsecase>().call(request);

    data.fold((error) {
      emit(GroupFailure(errorMessage: error.toString()));
    }, (data) async {
      emit(PostGroupSuccess(groupId: data, isSuccess: true));
    });
  }

  Future<void> getGroupList(GetGroupListReq request) async {
    emit(GroupLoading());
    var data = await sl<GetGroupListUsecase>().call(request);

    data.fold((error) {
      emit(GroupFailure(errorMessage: error.toString()));
    }, (data) async {
      emit(GetGroupListSuccess(
          pageSize: data.pageSize,
          pageNumber: data.pageNumber,
          totalCount: data.totalCount,
          totalPages: data.totalPages,
          hasNextPage: data.hasNextPage,
          hasPreviousPage: data.hasPreviousPage,
          groupList: data.groupList,
          hasMyGroups: data.hasMyGroups));
    });
  }

  Future<void> getGroupDetail(int groupId) async {
    emit(GroupLoading());

    final groupResult = await sl<GetGroupDetailUsecase>().call(groupId);
    await groupResult.fold(
      (error) async {
        emit(GroupFailure(errorMessage: error.toString()));
      },
      (group) async {
        final routeResult = await sl<GetGroupRouteUsecase>().call(groupId);
        await routeResult.fold(
          (error) async {
            //TODO Catch error when group route is private
            emit(GroupFailure(errorMessage: error.toString()));
          },
          (groupRoutes) async {
            final initialState = GetGroupDetailSuccess(
              group: group,
              groupRoutes: groupRoutes.groupList,
              cyclists: [],
            );

            emit(initialState);

            final participantResult =
                await sl<GetParticipantListUsecase>().call(groupId);

            participantResult.fold(
              (error) {
                emit(initialState.copyWith(cyclistsError: true));
              },
              (cyclistListResponse) {
                emit(initialState.copyWith(
                    cyclists: cyclistListResponse.cyclists));
              },
            );
          },
        );
      },
    );
  }

  Future<void> postGroupRoute(int groupId, PostGroupRouteReq request) async {
    emit(GroupLoading());
    final result = await sl<PostGroupRouteUsecase>()
        .call(PostGroupRouteParams(groupId: groupId, request: request));

    result.fold((error) {
      emit(GroupFailure(errorMessage: error.toString()));
    }, (data) {
      emit(PostGroupRouteSuccess(groupRoute: data, isSuccess: true));
    });
  }

  Future<void> leaveGroup(int groupId) async {
    if (state is! GetGroupDetailSuccess) return;

    var stateData = state as GetGroupDetailSuccess;
    var currentGroup = stateData.group;

    // Optional: prevent negative count
    final newParticipantCount = currentGroup.participantCount > 0
        ? currentGroup.participantCount - 1
        : 0;

    var newGroup = currentGroup.copyWith(
      membership: MembershipEnum.left,
      participantCount: newParticipantCount,
    );

    emit(GroupLoading());

    final result = await sl<LeaveGroupUsecase>().call(groupId);

    result.fold(
      (error) {
        emit(GroupFailure(errorMessage: error.message));
      },
      (_) {
        emit(GetGroupDetailSuccess(
          group: newGroup,
          groupRoutes: stateData.groupRoutes,
          cyclists: stateData.cyclists,
        ));
      },
    );
  }
}
