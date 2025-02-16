// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:tracio_fe/domain/blog/entites/blog.dart';

class BlogModels {
  BlogModels({
    required this.blogId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.privacySetting,
    required this.tittle,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.likesCount,
    required this.commentsCount,
  });

  final int blogId;
  final int userId;
  final String userName;
  final String avatar;
  final int privacySetting;
  final String tittle;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int commentsCount;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'blogId': blogId,
      'userId': userId,
      'userName': userName,
      'avatar': avatar,
      'privacySetting': privacySetting,
      'tittle': tittle,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
    };
  }

  factory BlogModels.fromMap(Map<String, dynamic> map) {
    return BlogModels(
      blogId: map['blogId'] as int,
      userId: map['userId'] as int,
      userName: map['userName'] ?? '', // Nếu null, thay bằng chuỗi rỗng
      avatar: map['avatar'] ?? '', // Nếu null, thay bằng chuỗi rỗng
      privacySetting: map['privacySetting'] as int,
      tittle: map['tittle'] ?? '', // Nếu null, thay bằng chuỗi rỗng
      content: map['content'] ?? '',
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
      likesCount: (map['likesCount'] ?? 0) as int, // Nếu null, gán 0
      commentsCount: (map['commentsCount'] ?? 0) as int, // Nếu null, gán 0
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogModels.fromJson(String source) =>
      BlogModels.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension BlogXModel on BlogModels {
  BlogEntity toEntity() {
    return BlogEntity(
        blogId: blogId,
        userId: userId,
        userName: userName,
        avatar: avatar,
        privacySetting: privacySetting,
        tittle: tittle,
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
        likesCount: likesCount,
        commentsCount: commentsCount);
  }
}
