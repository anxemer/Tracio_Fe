import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final UserEntity user;

  AuthLoaded({required this.user});
}

class AuthLoggedOut extends AuthState {}

class AuthFailure extends AuthState {
  final Failure failure;

  AuthFailure({required this.failure});
}
