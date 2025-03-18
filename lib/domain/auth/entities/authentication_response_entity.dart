class AuthenticationResponseEntity {
    final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  AuthenticationResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });
}
