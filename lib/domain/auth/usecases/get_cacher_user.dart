import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/auth/entities/user.dart';
import 'package:Tracio/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';

class GetCacherUserUseCase implements Usecase<UserEntity, NoParams> {
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return sl<AuthRepository>().getCacheUser();
  }
}
