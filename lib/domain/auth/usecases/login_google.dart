import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/auth/entities/authentication_response_entity.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class LoginGoogleUseCase extends Usecase<AuthenticationResponseEntity, NoParams> {
  @override
  Future<Either<Failure, AuthenticationResponseEntity>> call(params) async {
    return await sl<AuthRepository>().loginGoogle();
  }
}
