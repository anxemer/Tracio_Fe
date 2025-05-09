// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:Tracio/domain/auth/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    super.userId,
    super.userName,
    super.email,
    super.role,
    super.countRole,
    // super.firebaseId,
    // super.phoneNumber,
    super.profilePicture,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'userName': userName,
      'email': email,
      'role': role,
      'countRole': countRole,
      'profilePicture': profilePicture,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] != null ? map['userId'] as int : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      countRole: map['countRole'] != null ? map['countRole'] as String : null,
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
