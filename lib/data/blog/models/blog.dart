import '../../../domain/blog/entites/blog.dart';

class BlogModels {
  BlogModels({
    required this.blogId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.privacySetting,
    required this.isReacted,
    required this.reactionId,
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
  final int reactionId;
  final String content;
  final List<MediaFile> mediaFiles;
  final DateTime? createdAt;
  final DateTime? updatedAt;
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
      reactionId: json["reactionId"],
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
        "reactionId": reactionId,
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

extension BlogXModel on BlogModels {
  BlogEntity toEntity() {
    return BlogEntity(
        blogId: blogId,
        userId: userId,
        userName: userName,
        avatar: avatar,
        privacySetting: privacySetting,
        content: content,
        createdAt: createdAt!,
        updatedAt: updatedAt!,
        likesCount: likesCount,
        commentsCount: commentsCount,
        mediaFiles: mediaFiles,
        isReacted: isReacted,
        reactionId: reactionId);
  }
}
