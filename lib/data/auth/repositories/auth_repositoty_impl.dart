import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';
import 'package:tracio_fe/data/auth/sources/auth_api_service.dart';
import 'package:tracio_fe/data/auth/sources/auth_firebase_service.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';

class AuthRepositotyImpl extends AuthRepository {
  @override
  Future<Either> registerWithEmailAndPassword(RegisterReq user) async {
    return await sl<AuthApiService>().registerWithEmailAndPass(user);
  }

  @override
  Future<Either> verifyEmail(String email) async {
    return await sl<AuthFirebaseService>().verifyEmail(email);
  }

  @override
  Future<bool> checkEmailVerified() async {
    return await sl<AuthFirebaseService>().checkEmailVeriy();
  }

  @override
  Future<Either> login(LoginReq login) async {
    return await sl<AuthApiService>().login(login);
  }
}
