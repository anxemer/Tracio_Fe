import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/auth/models/login_req.dart';
import 'package:Tracio/domain/auth/entities/authentication_response_entity.dart';
import 'package:Tracio/domain/auth/repositories/auth_repository.dart';
import 'package:Tracio/service_locator.dart';

class LoginUseCase extends Usecase<AuthenticationResponseEntity, LoginReq> {
  @override
  Future<Either<Failure, AuthenticationResponseEntity>> call(LoginReq? params) async {
    return await sl<AuthRepository>().login(params!);
  }
}
