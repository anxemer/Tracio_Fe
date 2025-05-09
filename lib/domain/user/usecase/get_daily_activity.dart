import 'package:Tracio/domain/user/entities/daily_activity_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/user/repositories/user_profile_repository.dart';

import '../../../service_locator.dart';

class GetDailyActivityUseCase extends Usecase<DailyActivityEntity, NoParams> {
  @override
  Future<Either<Failure, DailyActivityEntity>> call(params) async {
    return await sl<UserProfileRepository>().getDailyActivity();
  }
}
