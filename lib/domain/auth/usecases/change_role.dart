import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/auth/models/change_role_req.dart';
import 'package:tracio_fe/domain/auth/entities/authentication_response_entity.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class ChangeRoleUseCase extends Usecase<AuthenticationResponseEntity, ChangeRoleReq> {
  @override
  Future<Either<Failure, AuthenticationResponseEntity>> call(params) async {
    return await sl<AuthRepository>().changeRole(params);
  }
}
