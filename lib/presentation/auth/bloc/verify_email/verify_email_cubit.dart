import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/auth/usecases/check_email_verified.dart';
import 'package:Tracio/domain/auth/usecases/verify_email.dart';
import 'package:Tracio/presentation/auth/bloc/verify_email/verify_email_state.dart';
import 'package:Tracio/service_locator.dart';

class VerifyEmailCubit extends Cubit<VerifyEmailState> {
  VerifyEmailCubit() : super(VerifyEmailInitial());

  Future<void> verifyEmail(String email) async {
    emit(VerifyEmailLoading());
    var result = await sl<VerifyEmailUseCase>().call(email);

    result.fold((l) {
      emit(VerifyEmailFailure(message: 'try again'));
    }, (firebaseId) async {
      await checkEmailVerified(email, firebaseId);
    });
  }

  Future<void> checkEmailVerified(String email, String firebaseId) async {
    emit(VerifyEmailLoading()); // Add this line to show waiting indicator again
    var result = await sl<CheckEmailVerifiedUseCase>().call(NoParams());
    result.fold((error) {
      emit(VerifyEmailFailure(message: 'Email chưa được xác minh'));
    }, (data) {
      if (data == true) {
        emit(VerifyEmailSuccess(email: email, firebaseId: firebaseId));
      } else {
        emit(VerifyEmailFailure(message: 'Email chưa được xác minh'));
      }
    });
  }
}
