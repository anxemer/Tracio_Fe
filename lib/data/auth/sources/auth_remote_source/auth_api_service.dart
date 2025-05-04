import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/erorr/exception.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/auth/models/change_role_req.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';
import 'package:tracio_fe/data/auth/sources/auth_remote_source/auth_firebase_service.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../models/authentication_respone_model.dart';

abstract class AuthApiService {
  Future<Either> registerWithEmailAndPass(RegisterReq params);
  Future<AuthenticationResponseModel> login(LoginReq login);
  Future<AuthenticationResponseModel> loginWithGoogleIdToken(String tokenId);
  Future<AuthenticationResponseModel> changeRole(ChangeRoleReq changRole);
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either> registerWithEmailAndPass(RegisterReq params) async {
    final formData = FormData.fromMap({
      "FirebaseUid": params.firebaseId,
      "Email": params.email,
      "UserName": params.fullName,
      // "password": params.password,
    });
    var response = await sl<DioClient>()
        .post(ApiUrl.registerWithEP, data: formData, isMultipart: true);

    await sl<AuthFirebaseService>().changePasswordFirebase(params.password);
    if (response.statusCode == 201) {
      return Right(true);
    } else if (response.data == 400) {
      throw CredentialFailure(response.data['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AuthenticationResponseModel> login(LoginReq login) async {
    var response = await sl<DioClient>()
        .post(ApiUrl.loginWithEP, data: login.toMap(), isMultipart: false);
    if (response.statusCode == 201) {
      return (AuthenticationResponseModel.fromMap(response.data['result']));
    } else if (response.statusCode == 400) {
      throw CredentialFailure("Lỗi server: ${response.data['message']}");
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AuthenticationResponseModel> changeRole(
      ChangeRoleReq changRole) async {
    final formData = FormData.fromMap({
      "RefreshToken": changRole.refreshToken,
      "Role": changRole.role,

      // "password": params.password,
    });
    var response = await sl<DioClient>()
        .post(ApiUrl.changeRole, data: formData, isMultipart: true);
    if (response.statusCode == 201) {
      return (AuthenticationResponseModel.fromMap(response.data['result']));
    } else if (response.statusCode == 400) {
      throw CredentialFailure("Lỗi server: ${response.data['message']}");
    } else {
      throw ServerException();
    }
  }

  @override
  Future<AuthenticationResponseModel> loginWithGoogleIdToken(
      String tokenId) async {
    final response =
        await DioClient().post(ApiUrl.loginWithEP, data: {"idToken": tokenId});
    if (response.statusCode == 201) {
      return (AuthenticationResponseModel.fromMap(response.data['result']));
    } else if (response.statusCode == 400) {
      throw CredentialFailure("Lỗi server: ${response.data['message']}");
    } else {
      throw ServerException();
    }
  }
}
