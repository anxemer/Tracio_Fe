part of 'follow_cubit.dart';

sealed class FollowState extends Equatable {
  const FollowState();

  @override
  List<Object> get props => [];
}

final class FollowInitial extends FollowState {}

final class FollowLoading extends FollowState {}

final class FollowLoaded extends FollowState {
  final List<FollowEntity> follow;

  const FollowLoaded(this.follow);
  @override
  List<Object> get props => [follow];
}

final class FollowFailure extends FollowState {
  final Failure failure;

  const FollowFailure(this.failure);
  @override
  List<Object> get props => [failure];
}
