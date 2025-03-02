import 'package:tracio_fe/core/erorr/failure.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {}

class AuthLoggedOut extends AuthState {}

class AuthFailure extends AuthState {
  final Failure failure;

  AuthFailure({required this.failure});
}
