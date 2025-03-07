// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:tracio_fe/domain/auth/entities/user.dart';

class UserModel extends UserEntity {
  final Session session;
  UserModel({
    super.userId,
    super.userName,
    super.email,
    super.firebaseId,
    super.phoneNumber,
    super.profilePicture,
    required this.session,
  });

  // Chuyển đối tượng thành Map để convert sang JSON
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'firebaseId': firebaseId,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'session': session.toMap(),
    };
  }

  // Tạo object từ Map JSON (Dùng khi API trả về dữ liệu)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as int,
      userName: map['userName'] as String,
      email: map['email'] as String,
      firebaseId: map['firebaseId'] as String,
      phoneNumber: map['phoneNumber'] as String,
      profilePicture: map['profilePicture'] as String? ?? "", // Tránh null
      session: Session.fromMap(map['session']),
    );
  }

  // Chuyển JSON string thành object
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  // Convert object sang JSON string
  String toJson() => json.encode(toMap());
}

class Session {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  Session({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  // Chuyển đối tượng thành Map JSON
  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  // Parse từ JSON Map
  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
      expiresAt:
          DateTime.parse(map['expiresAt']), // API trả về đầy đủ -> parse luôn
    );
  }

  // Convert JSON string thành object
  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source));

  // Convert object sang JSON string
  String toJson() => json.encode(toMap());
}
