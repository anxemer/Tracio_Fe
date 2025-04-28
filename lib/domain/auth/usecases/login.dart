import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/domain/auth/entities/authentication_response_entity.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class LoginUseCase extends Usecase<AuthenticationResponseEntity, LoginReq> {
  @override
  Future<Either<Failure, AuthenticationResponseEntity>> call(LoginReq? params) async {
    return await sl<AuthRepository>().login(params!);
  }
}
