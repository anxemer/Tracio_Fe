import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserEntity {
  final int? userId;
  final String? userName;
  final String? email;
  final String? role;
  final String? countRole;
  
  final String? profilePicture;
  UserEntity({
    this.userId,
    this.userName,
    this.email,
    this.role,
    this.countRole,
    this.profilePicture,
  });

  
}
