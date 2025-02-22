import 'package:tracio_fe/domain/auth/entities/user.dart';

class AuthenticationResponseModel {
  AuthenticationResponseModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.firebaseId,
    required this.phoneNumber,
    required this.profilePicture,
    required this.session,
  });

  final int? userId;
  final String? userName;
  final String? email;
  final String? firebaseId;
  final String? phoneNumber;
  final String? profilePicture;
  final Session? session;

  factory AuthenticationResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthenticationResponseModel(
      userId: json["userId"],
      userName: json["userName"],
      email: json["email"],
      firebaseId: json["firebaseId"],
      phoneNumber: json["phoneNumber"],
      profilePicture: json["profilePicture"],
      session:
          json["session"] == null ? null : Session.fromJson(json["session"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "email": email,
        "firebaseId": firebaseId,
        "phoneNumber": phoneNumber,
        "profilePicture": profilePicture,
        "session": session?.toJson(),
      };
}

class Session {
  Session({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  final String? accessToken;
  final String? refreshToken;
  final DateTime? expiresAt;

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
      expiresAt: DateTime.tryParse(json["expiresAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "expiresAt": expiresAt?.toIso8601String(),
      };
}

extension userXModel on AuthenticationResponseModel {
  UserEntity toEntity() {
    return UserEntity(
        userId, userName, email, firebaseId, phoneNumber, profilePicture);
  }
}
