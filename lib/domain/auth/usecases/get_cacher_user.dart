import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';

class GetCacherUserUseCase implements Usecase<UserEntity, NoParams> {
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return sl<AuthRepository>().getCacheUser();
  }
}
