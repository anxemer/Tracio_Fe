import 'package:Tracio/domain/challenge/entities/challenge_reward.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/challenge/repository/challenge_repository.dart';

import '../../../service_locator.dart';

class GetUserRewardUseCase extends Usecase<List<ChallengeRewardEntity>, int> {
  @override
  Future<Either<Failure, List<ChallengeRewardEntity>>> call(params) async {
    return await sl<ChallengeRepository>().getUserReward(params);
  }
}
