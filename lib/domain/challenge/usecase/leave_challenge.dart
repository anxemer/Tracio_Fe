import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/challenge/repository/challenge_repository.dart';

import '../../../service_locator.dart';

class LeaveChallengeUseCase extends Usecase<bool, int> {
  @override
  Future<Either<Failure, bool>> call(params) async {
    return await sl<ChallengeRepository>().leaveChallenge(params);
  }
}
