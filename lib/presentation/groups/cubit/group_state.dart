import 'package:tracio_fe/domain/groups/entities/group.dart';

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

class GetGroupListSuccess extends GroupState {
  int totalCount;
  int pageNumber;
  int pageSize;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;
  List<Group> groupList;
  GetGroupListSuccess({
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.groupList,
  });
}

class GetGroupDetailSuccess extends GroupState {
  Group group;
  GetGroupDetailSuccess({
    required this.group,
  });
}
