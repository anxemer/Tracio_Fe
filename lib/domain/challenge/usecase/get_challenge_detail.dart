import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';
import 'package:Tracio/domain/challenge/repository/challenge_repository.dart';

import '../../../service_locator.dart';

class GetChallengeDetailUseCase extends Usecase<ChallengeEntity, int> {
  @override
  Future<Either<Failure, ChallengeEntity>> call(params) async {
    return await sl<ChallengeRepository>().getChallengeDetail(params);
  }
}
