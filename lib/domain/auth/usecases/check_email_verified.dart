import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';

import '../../../service_locator.dart';
import '../repositories/auth_repository.dart';

class CheckEmailVerifiedUseCase extends Usecase<bool, NoParams> {
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await sl<AuthRepository>().checkEmailVerified();
  }
}
