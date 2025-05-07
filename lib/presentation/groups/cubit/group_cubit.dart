import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/constants/membership_enum.dart';
import 'package:Tracio/data/groups/models/request/get_group_list_req.dart';
import 'package:Tracio/data/groups/models/request/post_group_req.dart';
import 'package:Tracio/data/groups/models/request/post_group_route_req.dart';
import 'package:Tracio/domain/groups/usecases/get_group_detail_usecase.dart';
import 'package:Tracio/domain/groups/usecases/get_group_list_usecase.dart';
import 'package:Tracio/domain/groups/usecases/get_group_route_detail_usecase.dart';
import 'package:Tracio/domain/groups/usecases/get_group_route_usecase.dart';
import 'package:Tracio/domain/groups/usecases/get_participant_list_usecase.dart';
import 'package:Tracio/domain/groups/usecases/leave_group_usecase.dart';
import 'package:Tracio/domain/groups/usecases/post_group_route_usecase.dart';
import 'package:Tracio/domain/groups/usecases/post_group_usecase.dart';
import 'package:Tracio/presentation/groups/cubit/group_state.dart';
import 'package:Tracio/service_locator.dart';

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
                participants: [],
                groupRouteDetails: []);

            emit(initialState);

            final participantResult =
                await sl<GetParticipantListUsecase>().call(groupId);

            participantResult.fold(
              (error) {
                emit(initialState.copyWith(participantsError: true));
              },
              (cyclistListResponse) {
                emit(initialState.copyWith(
                    participants: cyclistListResponse.participants));
              },
            );
          },
        );
      },
    );
  }

  Future<void> getGroupRouteDetail(int groupRouteId,
      {int pageNumber = 1, int pageSize = 5}) async {
    final result = await sl<GetGroupRouteDetailUsecase>().call(
      GetGroupRouteDetailUsecaseParams(
        groupRouteId: groupRouteId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      ),
    );

    result.fold(
      (error) {
        if (state is GetGroupDetailSuccess) {
          var currentState = state as GetGroupDetailSuccess;
          emit(currentState.copyWith(
            groupRouteDetailsError: true,
          ));
        } else {
          emit(GroupFailure(errorMessage: error.toString()));
        }
      },
      (data) {
        if (state is GetGroupDetailSuccess) {
          var currentState = state as GetGroupDetailSuccess;
          emit(currentState.copyWith(
            groupRouteDetails: data.groupRouteDetails,
            groupRouteDetailsError: false,
          ));
        }
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
            participants: stateData.participants,
            groupRouteDetails: []));
      },
    );
  }
}
