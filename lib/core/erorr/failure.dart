// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message; // Thông báo lỗi chung

  const Failure(this.message);

  @override
  List<Object> get props => [message]; // So sánh dựa trên message
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class ExceptionFailure extends Failure {
  const ExceptionFailure(String message) : super(message);
}

class CredentialFailure extends Failure {
  const CredentialFailure(String message) : super(message);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(String message) : super(message);
}

class AuthorizationFailure extends Failure {
  final int statusCode;

  const AuthorizationFailure(super.message, this.statusCode);
}
