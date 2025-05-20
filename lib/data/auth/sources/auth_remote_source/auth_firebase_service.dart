import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/network/dio_client.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/api_url.dart';
import '../../../../service_locator.dart';

abstract class AuthFirebaseService {
  Future<String> verifyEmail(String email);
  Future<bool> checkEmailVerify();
  Future<Either> changePasswordFirebase(String pass);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<String> verifyEmail(String email) async {
    try {
      final formData = FormData.fromMap({
        "email": email,
      });

      var response =
          await sl<DioClient>().post(ApiUrl.sendVerifyEmail, data: formData);

      if (response.statusCode == 400) {
        throw CredentialFailure('Email is already verified.');
      }

      final String firebaseId = response.data['result']['uid'];

      return firebaseId;
    } on DioException catch (e) {
      throw Exception("Lỗi API: ${e.message}");
    } catch (e) {
      throw Exception("Lỗi không xác định: $e");
    }
  }

  @override
  Future<bool> checkEmailVerify(
      {int maxAttempts = 24,
      Duration delay = const Duration(seconds: 5)}) async {
    for (int i = 0; i < maxAttempts; i++) {
      final User? user = _firebaseAuth.currentUser;

      await user?.reload();

      if (user?.emailVerified ?? false) {
        return true;
      }

      await Future.delayed(delay);
    }
    return false;
  }

  @override
  Future<Either> changePasswordFirebase(String pass) async {
    try {
      User user = _firebaseAuth.currentUser!;

      await user.updatePassword(pass);

      return Right('Change password success');
    } on FirebaseAuthException catch (e) {
      return Left('Try again');
    }
  }
}
