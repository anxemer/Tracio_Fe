import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tracio_fe/core/erorr/exception.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/network_infor.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/auth/models/authentication_respone_model.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';
import 'package:tracio_fe/data/auth/models/user_model.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_api_service.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_firebase_service.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';

import '../../../domain/auth/entities/authentication_response_entity.dart';
import '../../../service_locator.dart';
import '../sources/auth_local_source/auth_local_source.dart';

typedef _DataSourceChoose = Future<AuthenticationResponseModel> Function();

class AuthRepositotyImpl extends AuthRepository {
  // final AuthLocalSource localSource;
  // final NetworkInfor networkInfor;

  @override
  Future<Either<Failure, bool>> registerWithEmailAndPassword(
      RegisterReq user) async {
    if (await sl<NetworkInfor>().isConnected) {
      try {
        await sl<AuthApiService>().registerWithEmailAndPass(user);
        return Right(true);
      } on Failure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure('Không có kết nối mạng'));
    }
  }

  @override
  Future<Either<Failure, String>> verifyEmail(String email) async {
    try {
      var result = await sl<AuthFirebaseService>().verifyEmail(email);
      return Right(result);
    } on FirebaseAuthException {
      return Left(ExceptionFailure('Verify email fail'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerified() async {
    try {
      bool isVerify = await sl<AuthFirebaseService>().checkEmailVerify();

      return Right(isVerify);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, AuthenticationResponseEntity>> login(login) async {
    return await _authenticate(() {
      return sl<AuthApiService>().login(login);
    });
  }

  @override
  Future<Either<Failure, bool>> isloggedIn() async {
    try {
      var token = await sl<AuthLocalSource>().getToken();
      if (token == '') {
        return Left(CacheFailure('Token null'));
      } else {
        return Right(true);
      }
    } on Exception catch (e) {
      return Left(NetworkFailure('Lỗi kết nối mạng'));
    }
    // final SharedPreferences sharedPreferences =
    //     await SharedPreferences.getInstance();
  }

  @override
  Future<Either<Failure, NoParams>> logout() async {
    try {
      await sl<AuthLocalSource>().clearCache();
      return Right(NoParams());
    } on CacheFailure {
      return Left(CacheFailure('Error'));
    }
  }

  Future<Either<Failure, AuthenticationResponseModel>> _authenticate(
      _DataSourceChoose getDataSource) async {
    try {
      final remoteResponse = await getDataSource();
      String token = remoteResponse.accessToken;
      String refreshToken = remoteResponse.refreshToken;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      int userId = int.parse(decodedToken['custom_id'].toString());
      String uniqueName = decodedToken['unique_name'];
      String role = decodedToken['role'];
      String email = decodedToken['email'];
      String avatar = decodedToken['avatar'];
      UserModel user = UserModel(
          role: role,
          email: email,
          profilePicture: avatar,
          userId: userId,
          userName: uniqueName);
      await sl<AuthLocalSource>().saveToken(token);
      await sl<AuthLocalSource>().saveRefrshToken(refreshToken);
      sl<AuthLocalSource>().saveUser(user);
      return Right(remoteResponse);
    } on CredentialFailure catch (e) {
      return Left(e);
    } on ServerException {
      return Left(ServerFailure('Network is unreachable'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCachUser() async {
    try {
      final user = await sl<AuthLocalSource>().getUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
