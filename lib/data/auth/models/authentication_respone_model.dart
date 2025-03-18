import 'dart:convert';

import 'package:tracio_fe/domain/auth/entities/authentication_response_entity.dart';

class AuthenticationResponseModel extends AuthenticationResponseEntity {
  AuthenticationResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
  });
  factory AuthenticationResponseModel.fromMap(Map<String, dynamic> map) {
    return AuthenticationResponseModel(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
      expiresAt: DateTime.parse(map['expiresAt']),
    );
  }

  // Convert JSON string thành object
  factory AuthenticationResponseModel.fromJson(String source) =>
      AuthenticationResponseModel.fromMap(json.decode(source));

  // Convert object sang JSON string
}
