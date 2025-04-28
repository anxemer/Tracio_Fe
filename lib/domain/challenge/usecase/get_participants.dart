import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/challenge/repository/challenge_repositories.dart';

import '../../../service_locator.dart';
import '../entities/participants_response_entity.dart';

class GetParticipantsUseCase extends Usecase<ParticipantsResponseEntity, int> {
  @override
  Future<Either<Failure, ParticipantsResponseEntity>> call(params) async {
    return await sl<ChallengeRepositories>().getParticipants(params);
  }
}
