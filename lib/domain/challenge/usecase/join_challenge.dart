import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/challenge/repository/challenge_repositories.dart';

import '../../../service_locator.dart';

class JoinChallengeUseCase extends Usecase<bool, int> {
  @override
  Future<Either<Failure, bool>> call(params) async {
    return await sl<ChallengeRepositories>().joinChallenge(params);
  }
}
