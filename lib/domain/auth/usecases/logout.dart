import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';

class LogoutUseCase extends Usecase<NoParams, NoParams> {
  @override
  Future<Either<Failure, NoParams>> call(NoParams params) async {
    return await sl<AuthRepository>().logout();
  }
}
