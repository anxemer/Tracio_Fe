import 'package:Tracio/domain/challenge/entities/challenge_reward.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';
import 'package:Tracio/domain/challenge/entities/participants_response_entity.dart';

import '../../../data/challenge/models/request/create_challenge_req.dart';
import '../entities/challenge_overview_response_entity.dart';

abstract class ChallengeRepository {
  Future<Either<Failure, ChallengeOverviewResponseEntity>>
      getChallengeOverview();
  Future<Either<Failure, ChallengeEntity>> getChallengeDetail(int challengeId);
  Future<Either<Failure, List<ChallengeRewardEntity>>> getUserReward(int userId);
  Future<Either<Failure, int>> joinChallenge(int challengeId);
  Future<Either<Failure, bool>> leaveChallenge(int challengeId);
  Future<Either<Failure, bool>> deleteChallenge(int challengeId);
  Future<Either<Failure, bool>> requestChallenge(int challengeId);
  Future<Either<Failure, ChallengeEntity>> createChallenge(CreateChallengeReq challenge);
  Future<Either<Failure, ParticipantsResponseEntity>> getParticipants(
      int challengeId);
}
