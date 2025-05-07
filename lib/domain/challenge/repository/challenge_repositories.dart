import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';
import 'package:Tracio/domain/challenge/entities/participants_response_entity.dart';

import '../entities/challenge_overview_response_entity.dart';

abstract class ChallengeRepositories {
  Future<Either<Failure, ChallengeOverviewResponseEntity>>
      getChallengeOverview();
  Future<Either<Failure, ChallengeEntity>> getChallengeDetail(int challengeId);
  Future<Either<Failure, ChallengeEntity>> getRewardUser(int userId);
  Future<Either<Failure, bool>> joinChallenge(int challengeId);
  Future<Either<Failure,ParticipantsResponseEntity>> getParticipants(
      int challengeId);
}
