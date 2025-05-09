import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';

class VerifyEmailUseCase implements Usecase<String, String> {
  @override
  Future<Either<Failure, String>> call(params) {
    return sl<AuthRepository>().verifyEmail(params);
  }
}
