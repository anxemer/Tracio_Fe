import 'dart:convert';

import '../../../../domain/blog/entites/blog_entity.dart';

List<BlogModels> blogModelListFromJson(String str) => List<BlogModels>.from(
    json.decode(str)['result']['blogs'].map((x) => BlogModels.fromJson(x)));

class BlogModels extends BlogEntity {
  BlogModels({
    required super.userId,
    required super.blogId,
    required super.userName,
    required super.avatar,
    required super.privacySetting,
    required super.isReacted,
    required super.isBookmarked,
    required super.content,
    required super.mediaFiles,
    required super.createdAt,
    required super.updatedAt,
    required super.likesCount,
    required super.commentsCount,
  });

  factory BlogModels.fromJson(Map<String, dynamic> json) {
    return BlogModels(
      blogId: json["blogId"],
      userId: json["userId"],
      userName: json["userName"],
      avatar: json["avatar"],
      privacySetting: json["privacySetting"],
      isReacted: json["isReacted"],
      isBookmarked: json["isBookmarked"],
      content: json["content"],
      mediaFiles: json["mediaFiles"] == null
          ? []
          : List<MediaFile>.from(
              json["mediaFiles"]!.map((x) => MediaFile.fromJson(x))),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
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
        "isBookmarked": isBookmarked,
        "content": content,
        "mediaFiles": mediaFiles.map((x) => x?.toJson()).toList(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "likesCount": likesCount,
        "commentsCount": commentsCount,
      };
}

class MediaFile {
  MediaFile({
    required this.mediaId,
    required this.mediaUrl,
  });

  final int? mediaId;
  final String? mediaUrl;

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      mediaId: json["mediaId"],
      mediaUrl: json["mediaUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "mediaId": mediaId,
        "mediaUrl": mediaUrl,
      };
}
