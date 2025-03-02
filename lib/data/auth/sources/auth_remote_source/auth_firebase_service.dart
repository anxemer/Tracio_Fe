import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';

abstract class AuthFirebaseService {
  Future<Either> verifyEmail(String email);
  Future<bool> checkEmailVeriy();
  Future<Either> changePasswordFirebase(String pass);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  @override
  Future<Either> verifyEmail(String email) async {
    try {
      String firebaseId;
      
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
      return left(true);
    } on FirebaseAuthException {
      String errorMessage = 'Lỗi không xác định.';

      return left(false);
    }
  }

  @override
  Future<bool> checkEmailVeriy() async {
    for (int i = 0; i <= 10; i++) {
      User? user = _firebaseAuth.currentUser;
     
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
