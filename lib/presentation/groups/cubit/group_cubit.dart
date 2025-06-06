import 'package:Tracio/domain/groups/usecases/delete_group_route_usecase.dart';
import 'package:Tracio/domain/groups/usecases/update_group_route_status_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/constants/membership_enum.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/groups/models/request/get_group_list_req.dart';
import 'package:Tracio/data/groups/models/request/get_group_participant_req.dart';
import 'package:Tracio/data/groups/models/request/get_group_route_req.dart';
import 'package:Tracio/data/groups/models/request/post_group_req.dart';
import 'package:Tracio/data/groups/models/request/post_group_route_req.dart';
import 'package:Tracio/domain/groups/entities/group_route.dart';
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
    if (request.pageNumber == 1) {
      emit(GroupLoading());
    }
    var data = await sl<GetGroupListUsecase>().call(request);

    data.fold((error) {
      emit(GroupFailure(errorMessage: error.toString()));
    }, (data) async {
      if (state is GetGroupListSuccess && request.pageNumber > 1) {
        final currentState = state as GetGroupListSuccess;
        emit(GetGroupListSuccess(
          pageSize: data.pageSize,
          pageNumber: data.pageNumber,
          totalCount: data.totalCount,
          totalPages: data.totalPages,
          hasNextPage: data.hasNextPage,
          hasPreviousPage: data.hasPreviousPage,
          groupList: [...currentState.groupList, ...data.groupList],
          hasMyGroups: data.hasMyGroups,
        ));
      } else {
        emit(GetGroupListSuccess(
          pageSize: data.pageSize,
          pageNumber: data.pageNumber,
          totalCount: data.totalCount,
          totalPages: data.totalPages,
          hasNextPage: data.hasNextPage,
          hasPreviousPage: data.hasPreviousPage,
          groupList: data.groupList,
          hasMyGroups: data.hasMyGroups,
        ));
      }
    });
  }

  Future<void> getGroupDetail(int groupId,
      {int participantPageNumber = 1,
      int participantRowsPerPage = 20,
      int groupRoutePageNumber = 1,
      int groupRouteRowsPerPage = 20}) async {
    emit(GroupLoading());

    final groupResult = await sl<GetGroupDetailUsecase>().call(groupId);

    await groupResult.fold(
      (error) async {
        emit(GroupFailure(errorMessage: error.message));
      },
      (group) async {
        GroupRoutePaginationEntity groupRoutes = GroupRoutePaginationEntity(
          groupRouteList: [],
          totalCount: 0,
          pageNumber: 1,
          pageSize: 10,
          totalPages: 0,
          hasPreviousPage: false,
          hasNextPage: false,
        );

        GroupParticipantPaginationEntity participants =
            GroupParticipantPaginationEntity(
          participants: [],
          totalCount: 0,
          pageNumber: 1,
          pageSize: 10,
          totalPages: 0,
          hasPreviousPage: false,
          hasNextPage: false,
        );

        bool groupRouteError = false;
        bool participantError = false;

        // ✅ Use helper for routes
        final routeResult = await getGroupRoutes(groupId,
            pageNumber: groupRoutePageNumber,
            rowsPerPage: groupRouteRowsPerPage);
        routeResult.fold(
          (error) => groupRouteError = true,
          (data) => groupRoutes = data,
        );

        // ✅ Use helper for participants
        final participantResult = await getParticipants(groupId,
            pageNumber: participantPageNumber,
            rowsPerPage: participantRowsPerPage);
        participantResult.fold(
          (error) => participantError = true,
          (data) => participants = data,
        );

        // ✅ Emit success with aggregated state
        emit(GetGroupDetailSuccess(
          group: group,
          groupRoutes: groupRoutes,
          participants: participants,
          groupRouteDetails: [],
          groupRouteDetailsError: groupRouteError,
          participantsError: participantError,
        ));
      },
    );
  }

  Future<Either<Failure, GroupRoutePaginationEntity>> getGroupRoutes(
      int groupId,
      {int pageNumber = 1,
      int rowsPerPage = 20}) {
    var groupRouteRequest = GetGroupRouteReq(
        groupId: groupId,
        pageNumber: pageNumber,
        rowsPerPage: rowsPerPage,
        sortDesc: true);
    return sl<GetGroupRouteUsecase>().call(groupRouteRequest);
  }

  Future<Either<Failure, GroupParticipantPaginationEntity>> getParticipants(
      int groupId,
      {int pageNumber = 1,
      int rowsPerPage = 10}) {
    var groupParticipantRequest = GetGroupParticipantReq(
        groupId: groupId, pageNumber: pageNumber, rowsPerPage: rowsPerPage);
    return sl<GetParticipantListUsecase>().call(groupParticipantRequest);
  }

  Future<void> getGroupRouteDetail(
      int groupRouteId, GetGroupDetailSuccess currentState,
      {int pageNumber = 1, int pageSize = 20}) async {
    final result = await sl<GetGroupRouteDetailUsecase>().call(
      GetGroupRouteDetailUsecaseParams(
        groupRouteId: groupRouteId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      ),
    );

    result.fold(
      (error) {
        emit(currentState.copyWith(
          groupRouteDetailsError: true,
        ));
      },
      (data) {
        emit(currentState.copyWith(
          groupRouteDetails: data.groupRouteDetails,
          groupRouteDetailsError: false,
        ));
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

  Future<void> updateGroupRouteStatus(GetGroupDetailSuccess? loadedState,
      int groupId, int groupRouteId, String status) async {
    emit(GroupLoading());
    UpdateGroupRouteStatusUsecaseParams params =
        UpdateGroupRouteStatusUsecaseParams(
            groupId: groupId, groupRouteId: groupRouteId, status: status);
    final result = await sl<UpdateGroupRouteStatusUsecase>().call(params);
    result.fold((error) {
      emit(GroupFailure(errorMessage: error.toString()));
    }, (data) {
      emit(PostGroupRouteSuccess(groupRoute: data, isSuccess: true));
    });
  }

  Future<void> deleteGroupRoute(int groupId, int groupRouteId) async {
    emit(DeleteGroupRouteLoading());
    DeleteGroupRouteUsecaseParams params = DeleteGroupRouteUsecaseParams(
        groupId: groupId, groupRouteId: groupRouteId);
    final result = await sl<DeleteGroupRouteUsecase>().call(params);
    result.fold((error) {
      emit(DeleteGroupRouteFailure(errorMessage: error.toString()));
    }, (data) {
      emit(DeleteGroupRouteSuccess());
    });
  }
}
