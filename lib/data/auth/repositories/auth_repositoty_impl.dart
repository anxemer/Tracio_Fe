import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/network_infor.dart';
import 'package:tracio_fe/data/auth/models/authentication_respone_model.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_api_service.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_firebase_service.dart';
import 'package:tracio_fe/data/auth/sources/authe_local_source/user_local_source.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';

typedef _DataSourceChoose = Future<AuthenticationResponseModel> Function();

class AuthRepositotyImpl extends AuthRepository {
  final AuthApiService remoteSource;
  final AuthLocalSource localSource;
  final NetworkInfor networkInfor;

  AuthRepositotyImpl(
      {required this.remoteSource,
      required this.localSource,
      required this.networkInfor});

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
  Future<Either<Failure, User>> login(LoginReq login) async {
    var data = await sl<AuthApiService>().login(login);
    return data.fold((error) => left(error), (data) async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String accessToken = data['result']['session']['accessToken'];
      sharedPreferences.setString('accessToken', accessToken);
      return right(data);
    });
  }

  @override
  Future<bool> isloggedIn() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('accessToken');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }

  // Future<Either<Failure, User>> _authenticate(
  //     _DataSourceChoose getDataSource) async {
  //   if (await networkInfor.isConnected) {
  //     try {
  //       final remoteResponse = await getDataSource();
  //       localSource.saveToken(remoteResponse.session.accessToken.toString());
  //     } catch (e) {}
  //   }
  // }
}
