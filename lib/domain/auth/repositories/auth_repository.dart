import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/auth/models/change_role_req.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';

import '../../../data/auth/models/authentication_respone_model.dart';
import '../entities/authentication_response_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> registerWithEmailAndPassword(RegisterReq user);
  Future<Either<Failure, String>> verifyEmail(String email);
  Future<Either<Failure, bool>> checkEmailVerified();
  Future<Either<Failure, AuthenticationResponseEntity>> login(LoginReq login);
  Future<Either<Failure, AuthenticationResponseModel>> loginGoogle();
  Future<Either<Failure, AuthenticationResponseEntity>> changeRole(
      ChangeRoleReq changeRole);
  Future<Either<Failure, String>> isLoggedIn();
  Future<Either<Failure, NoParams>> logout();
  Either<Failure, UserEntity> getCacheUser();
}
