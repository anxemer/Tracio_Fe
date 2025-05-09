// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class SplashState {}

class SplashLoading extends SplashState {}

class Authenticated extends SplashState {
  final String role;
  Authenticated({
    required this.role,
  });
}

class UnAuthenticated extends SplashState {}
