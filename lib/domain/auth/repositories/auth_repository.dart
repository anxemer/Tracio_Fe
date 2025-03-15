import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> registerWithEmailAndPassword(RegisterReq user);
  Future<Either<Failure, String>> verifyEmail(String email);
  Future<Either<Failure, bool>> checkEmailVerified();
  Future<Either<Failure, UserEntity>> login(LoginReq login);
  Future<Either<Failure, bool>> isloggedIn();
  Future<Either<Failure, NoParams>> logout();
  Future<Either<Failure, UserEntity>> getCachUser();
}
