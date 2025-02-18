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
    required this.isReacted,
    required this.content,
    required this.mediaFiles,
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
  final bool isReacted;
  final String content;
  final List<dynamic> mediaFiles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int commentsCount;

  factory BlogModels.fromJson(Map<String, dynamic> json) {
    return BlogModels(
      blogId: json["blogId"],
      userId: json["userId"],
      userName: json["userName"],
      avatar: json["avatar"],
      privacySetting: json["privacySetting"],
      isReacted: json["isReacted"],
      content: json["content"],
      mediaFiles: json["mediaFiles"] == null
          ? []
          : List<dynamic>.from(json["mediaFiles"]!.map((x) => x)),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      likesCount: json["likesCount"],
      commentsCount: json["commentsCount"],
    );
  }

  Map<String, dynamic> toJson() => {
        "blogId": blogId,
        "userId": userId,
        "userName": userName,
        "avatar": avatar,
        "privacySetting": privacySetting,
        "isReacted": isReacted,
        "content": content,
        "mediaFiles": mediaFiles.map((x) => x).toList(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "likesCount": likesCount,
        "commentsCount": commentsCount,
      };
}

extension BlogXModel on BlogModels {
  BlogEntity toEntity() {
    return BlogEntity(
        blogId: blogId,
        userId: userId,
        userName: userName,
        avatar: avatar,
        privacySetting: privacySetting,
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
        likesCount: likesCount,
        commentsCount: commentsCount,
        mediaFiles: mediaFiles,
        isReacted: isReacted);
  }
}
