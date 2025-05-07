import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/challenge/entities/challenge_overview_response_entity.dart';
import 'package:Tracio/domain/challenge/repository/challenge_repositories.dart';

import '../../../service_locator.dart';

class GetChallengeOverviewUseCase
    extends Usecase<ChallengeOverviewResponseEntity, NoParams> {
  @override
  Future<Either<Failure, ChallengeOverviewResponseEntity>> call(params) async {
    return await sl<ChallengeRepositories>().getChallengeOverview();
  }
}
