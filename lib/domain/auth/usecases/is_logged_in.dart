import 'package:dartz/dartz.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/auth/repositories/auth_repository.dart';
import 'package:Tracio/service_locator.dart';

import '../../../core/erorr/failure.dart';

class IsLoggedInUseCase implements Usecase<String, NoParams> {
  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return await sl<AuthRepository>().isLoggedIn();
  }
}
