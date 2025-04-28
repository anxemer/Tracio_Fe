import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/challenge/entities/challenge_overview_response_entity.dart';
import 'package:tracio_fe/domain/challenge/repository/challenge_repositories.dart';

import '../../../service_locator.dart';

class GetChallengeOverviewUseCase
    extends Usecase<ChallengeOverviewResponseEntity, NoParams> {
  @override
  Future<Either<Failure, ChallengeOverviewResponseEntity>> call(params) async {
    return await sl<ChallengeRepositories>().getChallengeOverview();
  }
}
