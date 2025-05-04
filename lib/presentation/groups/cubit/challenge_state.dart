part of 'challenge_cubit.dart';

sealed class ChallengeState extends Equatable {
  const ChallengeState();

  @override
  List<Object> get props => [];
}

final class ChallengeInitial extends ChallengeState {}

final class ChallengeLoading extends ChallengeState {}

final class ChallengeLoaded extends ChallengeState {
  final ChallengeOverviewResponseEntity challengeOverview;

  const ChallengeLoaded(this.challengeOverview);
  @override
  List<Object> get props => [challengeOverview];
}

final class ChallengeFailure extends ChallengeState {
  final String message;
  final Failure failure;

  const ChallengeFailure(this.message, this.failure);
}

final class ChallengeDetailLoaded extends ChallengeState {
  final ChallengeEntity challenge;

  const ChallengeDetailLoaded(this.challenge);
  @override
  List<Object> get props => [challenge];
}

final class JoinChallengeLoaded extends ChallengeState {}
