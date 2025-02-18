import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';

abstract class AuthRepository {
  Future<Either> registerWithEmailAndPassword(RegisterReq user);
  Future<Either> verifyEmail(String email);
  Future<bool> checkEmailVerified();
  Future<Either> login(LoginReq login);
  Future<bool> isloggedIn();
  Future<void> logout();
}
