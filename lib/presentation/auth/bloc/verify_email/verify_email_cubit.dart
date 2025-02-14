import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/domain/auth/usecases/check_email_verified.dart';
import 'package:tracio_fe/domain/auth/usecases/verify_email.dart';
import 'package:tracio_fe/presentation/auth/bloc/verify_email/verify_email_state.dart';
import 'package:tracio_fe/service_locator.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit() : super(VerifyEmailInitial());

  Future<void> verifyEmail(String email) async {
    emit(VerifyEmailLoading());
    var result = await sl<VerifyEmailUseCase>().call(params: email);

    result.fold((l) {
      emit(VerifyEmailFailure(message: 'try again'));
    }, (firebaseId) async {
      await checkEmailVerified(email, firebaseId);
    });
  }

  Future<void> checkEmailVerified(String email, String firebaseId) async {
    var result = await sl<CheckEmailVerifiedUseCase>().call();
    print('Check email verified result: $result');
    if (result) {
      emit(VerifyEmailSuccess(email: email, firebaseId: firebaseId));
    } else {
      emit(VerifyEmailFailure(message: 'Email chưa được xác minh'));
    }
  }
}
