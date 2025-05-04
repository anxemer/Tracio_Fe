import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        return firebaseId;
      }
      return 'Verify email failed';
    } on FirebaseAuthException {
      String errorMessage = 'Lỗi không xác định.';

      return errorMessage;
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
      User user = await _firebaseAuth.currentUser!;

      var result = await user.updatePassword(pass);

      return right('Change password success');
    } on FirebaseAuthException catch (e) {
      return left('Try again');
    }
  }
}
