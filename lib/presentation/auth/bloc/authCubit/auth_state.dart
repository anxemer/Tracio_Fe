import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';

import '../../../../domain/auth/entities/authentication_response_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoaded extends AuthState {
  final UserEntity ? user;

  AuthLoaded({ this.user});
}

class AuthLoggedOut extends AuthState {}

class AuthFailure extends AuthState {
  final Failure failure;

  AuthFailure(this.failure);
}
