part of 'follow_cubit.dart';

sealed class FollowState extends Equatable {
  final List<FollowEntity> follow;
  final PaginationFollowDataEntity pagination;
  final GetFollowReq params;

  const FollowState(this.follow, this.pagination, this.params);

  @override
  List<Object> get props => [follow, pagination, params];
}

final class FollowInitial extends FollowState {
  FollowInitial(super.follow, super.pagination, super.params);
}

final class FollowLoading extends FollowState {
  FollowLoading(super.follow, super.pagination, super.params);
}

final class FollowLoaded extends FollowState {
  const FollowLoaded(super.follow, super.pagination, super.params);
}

final class FollowFailure extends FollowState {
  final Failure failure;

  const FollowFailure(
      super.follow, super.pagination, super.params, this.failure);
  @override
  List<Object> get props => [follow,pagination,params,failure];
}
