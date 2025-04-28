import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/challenge/entities/challenge_entity.dart';
import 'package:tracio_fe/domain/challenge/repository/challenge_repositories.dart';

import '../../../service_locator.dart';

class GetChallengeDetailUseCase
    extends Usecase<ChallengeEntity, int> {
  @override
  Future<Either<Failure, ChallengeEntity>> call(params) async {
    return await sl<ChallengeRepositories>().getChallengeDetail(params);
  }
}
