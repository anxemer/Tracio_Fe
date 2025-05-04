import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/user/repositories/user_profile_repository.dart';

import '../../../service_locator.dart';

class FollowUserUseCase extends Usecase<bool, int> {
  @override
  Future<Either<Failure, bool>> call(int params) async {
    return await sl<UserProfileRepository>().followUser(params);
  }
}
