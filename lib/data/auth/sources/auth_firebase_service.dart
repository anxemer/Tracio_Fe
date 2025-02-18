import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';

abstract class AuthFirebaseService {
  // Future<Either> registerWithEmailAndPassword(RegisterReq user);
  Future<Either> verifyEmail(String email);
  Future<bool> checkEmailVeriy();
  Future<Either> changePasswordFirebase(String pass);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // @override
  // Future<Either> registerWithEmailAndPassword(RegisterReq user) async {
  //   try {
  //     var data = await _firebaseAuth.createUserWithEmailAndPassword(
  //         email: user.email, password: user.password);
  //     return right(data);
  //   } on FirebaseAuthException catch (e) {
  //     String message = '';

  //     if (e.code == 'weak-password') {
  //       message = 'The password provided is too weak';
  //     } else if (e.code == 'email-already-in-use') {
  //       message = 'An account already exists with that email.';
  //     }

  //     return Left(message);
  //   }
  // }

  @override
  Future<Either> verifyEmail(String email) async {
    try {
      String firebaseId;
      print("⏳ Đang tạo tài khoản với email: $email");
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: '12345678');
      User? user = userCredential.user;
      await user?.reload(); // Refresh user
      await Future.delayed(Duration(seconds: 2));
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: '12345678');
      if (user != null && !user.emailVerified) {
        firebaseId = user.uid;
        await user.sendEmailVerification();
        return right(firebaseId);
      }
      return left('Email is already verified or user does not exist.');
    } on FirebaseAuthException {
      String errorMessage = 'Lỗi không xác định.';

      return left(errorMessage);
    }
  }

  @override
  Future<bool> checkEmailVeriy() async {
    for (int i = 0; i <= 10; i++) {
      User? user = _firebaseAuth.currentUser;
      print("🔄 Kiểm tra lần thứ, emailVerified = ${user?.emailVerified}");
      await Future.delayed(Duration(seconds: 3)); // Kiểm tra sau mỗi 3 giây
      await user?.reload(); // Refresh user info

      if (user?.emailVerified ?? false) {
        return true; // Email đã được xác minh
      }
    }
    return false;
  }

  @override
  Future<Either> changePasswordFirebase(String pass) async {
    try {
      User user = await _firebaseAuth.currentUser!;
      var result = await user.updatePassword(pass);

      return right('Change password success');
    } on FirebaseAuthException catch (e) {
      return left('Try again');
    }
  }
}
