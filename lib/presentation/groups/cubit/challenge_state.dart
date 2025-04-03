part of 'challenge_cubit.dart';

sealed class ChallengeState extends Equatable {
  const ChallengeState();

  @override
  List<Object> get props => [];
}

final class ChallengeInitial extends ChallengeState {}
