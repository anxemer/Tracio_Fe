import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracio_fe/core/erorr/exception.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/network_infor.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/auth/models/authentication_respone_model.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';
import 'package:tracio_fe/data/auth/models/user_model.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_api_service.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_firebase_service.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';
import 'package:tracio_fe/domain/auth/repositories/auth_repository.dart';

import '../../../service_locator.dart';
import '../sources/auth_local_source/auth_local_source.dart';

typedef _DataSourceChoose = Future<UserModel> Function();

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
    if (await sl<NetworkInfor>().isConnected) {
      try {
        await sl<AuthFirebaseService>().verifyEmail(email);
        return Right('Verify Susscess');
      } on Failure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure('Không có kết nối mạng'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkEmailVerified() async {
    if (await sl<NetworkInfor>().isConnected) {
      try {
        await sl<AuthFirebaseService>().checkEmailVeriy();

        return Right(true);
      } on Failure catch (e) {
        return Left(e);
      }
    } else {
      return Left(NetworkFailure('Không có kết nối mạng'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> login(login) async {
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
    } on CacheException catch (e) {
      return Left(CacheFailure('Token not found'));
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

  Future<Either<Failure, UserModel>> _authenticate(
      _DataSourceChoose getDataSource) async {
    bool isConnected = await sl<NetworkInfor>().isConnected;
    // print("Kết nối mạng: $isConnected");

    // print('Token $token');
    if (isConnected) {
      try {
        final remoteResponse = await getDataSource();
        String token = remoteResponse.session.accessToken;
        print(token);
        await sl<AuthLocalSource>().saveToken(token);
        print(remoteResponse);
        sl<AuthLocalSource>().saveUser(remoteResponse);
        return Right(remoteResponse);
      } on DioException catch (e) {
        if (e.response != null) {
          return Left(ServerFailure(
              e.response?.data['message'] ?? "Lỗi server: ${e.message}"));
        } else {
          return Left(NetworkFailure("Không có kết nối mạng: ${e.message}"));
        }
      } catch (e) {
        return Left(ExceptionFailure("Lỗi không xác định: $e"));
      }
    }

    return Left(NetworkFailure("Không có kết nối mạng"));
  }

  @override
  Future<Either<Failure, UserEntity>> getCachUser() async {
    try {
      final user = await sl<AuthLocalSource>().getUser();
      return Right(user);
      // ignore: empty_catches
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
