import 'package:Tracio/data/challenge/models/request/create_challenge_req.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/challenge/repository/challenge_repository.dart';

import '../../../service_locator.dart';
import '../entities/challenge_entity.dart';

class CreateChallengeUseCase extends Usecase<ChallengeEntity, CreateChallengeReq> {
  @override
  Future<Either<Failure, ChallengeEntity>> call(params) async {
    return await sl<ChallengeRepository>().createChallenge(params);
  }
}
