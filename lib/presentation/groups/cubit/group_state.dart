import 'package:tracio_fe/data/groups/models/response/get_participant_list_rep.dart';
import 'package:tracio_fe/domain/groups/entities/group.dart';
import 'package:tracio_fe/domain/groups/entities/group_route.dart';

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
  final List<GroupRouteEntity> groupRoutes;
  final List<Cyclist> cyclists;
  final bool cyclistsError;

  GetGroupDetailSuccess({
    required this.group,
    required this.groupRoutes,
    required this.cyclists,
    this.cyclistsError = false,
  });

  GetGroupDetailSuccess copyWith({
    Group? group,
    List<GroupRouteEntity>? groupRoutes,
    List<Cyclist>? cyclists,
    bool? cyclistsError,
  }) {
    return GetGroupDetailSuccess(
      group: group ?? this.group,
      groupRoutes: groupRoutes ?? this.groupRoutes,
      cyclists: cyclists ?? this.cyclists,
      cyclistsError: cyclistsError ?? this.cyclistsError,
    );
  }
}
