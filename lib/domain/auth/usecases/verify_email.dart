import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';

class VerifyEmailUseCase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) {
    return sl<AuthRepository>().verifyEmail(params!);
  }
}
