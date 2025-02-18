abstract class VerifyEmailState {}

class VerifyEmailLoading extends VerifyEmailState {}

class VerifyEmailInitial extends VerifyEmailState {}

class VerifyEmailSuccess extends VerifyEmailState {
  final String? email;
  final String? firebaseId;
  VerifyEmailSuccess({this.email, this.firebaseId});
}

class VerifyEmailFailure extends VerifyEmailState {
  final String message; // Thông báo lỗi

  VerifyEmailFailure({required this.message});
}
