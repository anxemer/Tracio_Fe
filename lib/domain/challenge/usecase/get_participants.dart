import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/challenge/repository/challenge_repository.dart';

import '../../../service_locator.dart';
import '../entities/participants_response_entity.dart';

class GetParticipantsUseCase extends Usecase<ParticipantsResponseEntity, int> {
  @override
  Future<Either<Failure, ParticipantsResponseEntity>> call(params) async {
    return await sl<ChallengeRepository>().getParticipants(params);
  }
}
