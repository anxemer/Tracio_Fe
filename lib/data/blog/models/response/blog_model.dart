import '../../../../common/helper/media_file.dart';
import '../../../../domain/blog/entites/blog_entity.dart';

class BlogModels extends BlogEntity {
  BlogModels({
    required super.userId,
    required super.blogId,
    required super.userName,
    required super.avatar,
    required super.isPublic,
    required super.isReacted,
    required super.isBookmarked,
    required super.content,
    required super.mediaFiles,
    required super.createdAt,
    required super.updatedAt,
    required super.likesCount,
    required super.commentsCount,
    required super.isFollowed,
  });

  factory BlogModels.fromJson(Map<String, dynamic> json) {
    return BlogModels(
      blogId: json["blogId"] ?? 0,
      userId: json["creatorId"] ?? 0,
      userName: json["creatorName"] ?? "",
      avatar: json["creatorAvatar"] ?? "",
      isPublic: json["isPublic"] ?? true,
      isReacted: json["isReacted"] ?? false,
      isBookmarked: json["isBookmarked"] ?? false,
      content: json["content"] ?? "",
      mediaFiles: (json["mediaFiles"] != null && json["mediaFiles"] is List)
          ? List<MediaFile>.from(
              json["mediaFiles"].map((x) => MediaFile.fromJson(x)))
          : [],
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.tryParse(json["updatedAt"])
          : null,
      likesCount: json["likeCount"] ?? 0,
      commentsCount: json["commentCount"] ?? 0,
      isFollowed: json["isFollowed"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "blogId": blogId,
        "userId": userId,
        "userName": userName,
        "avatar": avatar,
        "isPublic": isPublic,
        "isReacted": isReacted,
        "isBookmarked": isBookmarked,
        "content": content,
        "mediaFiles": mediaFiles.map((x) => x.toJson()).toList(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "likesCount": likesCount,
        "commentsCount": commentsCount,
      };
}
