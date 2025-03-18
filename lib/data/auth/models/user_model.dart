// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:tracio_fe/domain/auth/entities/user.dart';

class UserModel extends UserEntity {
  UserModel({
    super.userId,
    super.userName,
    super.email,
    // super.firebaseId,
    // super.phoneNumber,
    super.profilePicture,
  });

  // Chuyển đối tượng thành Map để convert sang JSON
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'profilePicture': profilePicture,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as int,
      userName: map['userName'] as String,
      email: map['email'] as String,
      // firebaseId: map['firebaseId'] as String ,
      // phoneNumber: map['phoneNumber'] as String ,
      profilePicture: map['profilePicture'] as String? ?? "", // Tránh null
    );
  }

  // Chuyển JSON string thành object
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  // Convert object sang JSON string
  String toJson() => json.encode(toMap());
}


