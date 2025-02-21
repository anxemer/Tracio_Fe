import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';
import 'package:tracio_fe/data/auth/sources/auth_firebase_service.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class AuthApiService {
  Future<Either> registerWithEmailAndPass(RegisterReq params);
  Future<Either> login(LoginReq login);
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either> registerWithEmailAndPass(RegisterReq params) async {
    try {
      final formData = FormData.fromMap({
        "FirebaseUid": params.firebaseId,
        "Email": params.email,
        "UserName": params.fullName,
        // "password": params.password,
      });
      var response = await sl<DioClient>()
          .post(ApiUrl.registerWithEP, data: formData, isMultipart: true);

      await sl<AuthFirebaseService>().changePasswordFirebase(params.password);
      return right(response.data);
    } on DioException catch (e) {
      return left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> login(LoginReq login) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.loginWithEP, data: login.toMap(), isMultipart: false);
      return right(response.data);
    } on DioException catch (e) {
      return left(e.response!.data['result']);
    }
  }
}
