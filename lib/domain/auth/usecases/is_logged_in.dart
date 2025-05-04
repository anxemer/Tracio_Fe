import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../../core/erorr/failure.dart';

class IsLoggedInUseCase implements Usecase<String, NoParams> {
  @override
  Future<Either<Failure,String>> call(NoParams params) async {
    return await sl<AuthRepository>().isloggedIn();
  }
}
