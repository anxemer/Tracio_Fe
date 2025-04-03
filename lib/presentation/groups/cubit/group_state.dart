// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  bool isSuccess;
  PostGroupSuccess({
    required this.isSuccess,
  });
}

class GetGroupsSuccess extends GroupState {}

class GetGroupDetailSuccess extends GroupState {}
