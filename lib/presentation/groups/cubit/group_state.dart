import 'package:Tracio/domain/groups/entities/group.dart';
import 'package:Tracio/domain/groups/entities/group_route.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupFailure extends GroupState {
  String errorMessage;
  GroupFailure({
    required this.errorMessage,
  });
}

class PostGroupSuccess extends GroupState {
  int groupId;
  bool isSuccess;
  PostGroupSuccess({
    required this.groupId,
    required this.isSuccess,
  });
}

class PostGroupRouteSuccess extends GroupState {
  GroupRouteEntity groupRoute;
  bool isSuccess;
  PostGroupRouteSuccess({
    required this.groupRoute,
    required this.isSuccess,
  });
}

class GetGroupListSuccess extends GroupState {
  int totalCount;
  int pageNumber;
  int pageSize;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;
  bool hasMyGroups;
  List<Group> groupList;
  GetGroupListSuccess({
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.groupList,
    required this.hasMyGroups,
  });
}

class GetGroupDetailSuccess extends GroupState {
  final Group group;
  final GroupRoutePaginationEntity groupRoutes;
  final GroupParticipantPaginationEntity participants;
  final List<GroupRouteDetail> groupRouteDetails;
  final bool groupError;
  final bool participantsError;
  final bool groupRouteDetailsError;

  GetGroupDetailSuccess({
    required this.group,
    required this.groupRoutes,
    required this.participants,
    required this.groupRouteDetails,
    this.groupError = false,
    this.participantsError = false,
    this.groupRouteDetailsError = false,
  });

  GetGroupDetailSuccess copyWith({
    Group? group,
    GroupRoutePaginationEntity? groupRoutes,
    GroupParticipantPaginationEntity? participants,
    List<GroupRouteDetail>? groupRouteDetails,
    bool? groupError,
    bool? participantsError,
    bool? groupRouteDetailsError,
  }) {
    return GetGroupDetailSuccess(
      group: group ?? this.group,
      groupRoutes: groupRoutes ?? this.groupRoutes,
      participants: participants ?? this.participants,
      groupRouteDetails: groupRouteDetails ?? this.groupRouteDetails,
      groupError: groupError ?? this.groupError,
      participantsError: participantsError ?? this.participantsError,
      groupRouteDetailsError:
          groupRouteDetailsError ?? this.groupRouteDetailsError,
    );
  }
}
