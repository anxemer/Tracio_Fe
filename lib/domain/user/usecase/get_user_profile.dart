import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';
import 'package:tracio_fe/domain/user/repositories/user_profile_repository.dart';

import '../../../service_locator.dart';

class GetUserProfileUseCase extends Usecase<UserProfileEntity, int> {
  @override
  Future<Either<Failure, UserProfileEntity>> call(int params) async {
    return await sl<UserProfileRepository>().getUserProfile(params);
  }
}
