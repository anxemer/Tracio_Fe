import 'dart:ffi';
import 'dart:io';

import 'package:Tracio/data/user/models/send_fcm_req.dart';
import 'package:dartz/dartz.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:Tracio/core/erorr/exception.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/network/network_infor.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/auth/models/authentication_respone_model.dart';
import 'package:Tracio/data/auth/models/register_req.dart';
import 'package:Tracio/data/auth/models/user_model.dart';
import 'package:Tracio/data/auth/sources/auth_remote_source/auth_api_service.dart';
import 'package:Tracio/data/auth/sources/auth_remote_source/auth_firebase_service.dart';
import 'package:Tracio/domain/auth/entities/user.dart';
import 'package:Tracio/domain/auth/repositories/auth_repository.dart';

import '../../../domain/auth/entities/authentication_response_entity.dart';
import '../../../service_locator.dart';
import '../../user/source/user_api_source.dart';
import '../models/change_role_req.dart';
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
      return Left(ExceptionFailure('Không có kết nối mạng'));
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
  Future<Either<Failure, String>> isLoggedIn() async {
    try {
      var user = sl<AuthLocalSource>().getUser();
      if (user != null) {
        return Right(user.role!);
      } else {
        return Left(AuthenticationFailure("User not found"));
      }
    } on Exception catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoParams>> logout() async {
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      googleSignIn.currentUser?.clearAuthCache();
      googleSignIn.signOut();
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
      String countRole = decodedToken['count_role'];
      UserModel user = UserModel(
          countRole: countRole,
          role: role,
          email: email,
          profilePicture: avatar,
          userId: userId,
          userName: uniqueName);
      await sl<AuthLocalSource>().saveToken(token);
      await sl<AuthLocalSource>().saveRefreshToken(refreshToken);
      sl<AuthLocalSource>().saveUser(user);
      return Right(remoteResponse);
    } on CredentialFailure catch (e) {
      return Left(e);
    } on ServerException {
      return Left(ServerFailure('Network is unreachable'));
    }
  }

  @override
  Either<Failure, UserEntity> getCacheUser() {
    try {
      final user = sl<AuthLocalSource>().getUser();
      if (user != null) {
        return Right(user);
      } else {
        return Left(AuthenticationFailure("User not found"));
      }
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthenticationResponseEntity>> changeRole(
      ChangeRoleReq changeRole) async {
    return await _authenticate(() {
      return sl<AuthApiService>().changeRole(changeRole);
    });
  }

  @override
  Future<Either<Failure, AuthenticationResponseModel>> loginGoogle() async {
    return _authenticate(() async {
      final googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
      final isSignedIn = googleSignIn.currentUser != null;
      if (isSignedIn) {
        await googleSignIn.signOut();
      }

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw CredentialFailure('Login Google fail');
      }

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebaseUser =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final firebaseIdToken = await firebaseUser.user?.getIdToken();
      if (firebaseIdToken == null) {
        throw CredentialFailure('Firebase ID Token not found');
      }

      print(firebaseIdToken);

      // Gửi ID Token Firebase về server
      return await sl<AuthApiService>().loginWithGoogleIdToken(firebaseIdToken);
    });
  }

  @override
  Future<Either<Failure, bool>> sendFcm(SendFcmReq fcm) async {
    try {
      await sl<UserApiSource>().sendFcm(fcm);

      return Right(true);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
