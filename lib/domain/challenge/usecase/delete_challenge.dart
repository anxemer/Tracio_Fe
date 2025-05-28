import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/challenge/repository/challenge_repository.dart';

import '../../../service_locator.dart';

class DeleteChallengeUseCase extends Usecase<bool, int> {
  @override
  Future<Either<Failure, bool>> call(params) async {
    return await sl<ChallengeRepository>().deleteChallenge(params);
  }
}
