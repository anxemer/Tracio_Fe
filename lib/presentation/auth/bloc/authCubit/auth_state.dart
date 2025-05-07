// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/domain/auth/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final UserEntity? user;

  AuthLoaded({this.user});
}

class AuthLoggedOut extends AuthState {}

class AuthGoogleLoginUrlReceived extends AuthState {
  final String loginUrl;
  AuthGoogleLoginUrlReceived(this.loginUrl);
}

class AuthChangeRole extends AuthState {
  final UserEntity? user;
  AuthChangeRole({
    this.user,
  });
}

class AuthFailure extends AuthState {
  final Failure failure;

  AuthFailure(this.failure);
}
