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
  });

  factory BlogModels.fromJson(Map<String, dynamic> json) {
    return BlogModels(
      blogId: json["blogId"],
      userId: json["creatorId"],
      userName: json["creatorName"],
      avatar: json["creatorAvatar"],
      isPublic: json["isPublic"],
      isReacted: json["isReacted"],
      isBookmarked: json["isBookmarked"],
      content: json["content"],
      mediaFiles: json["mediaFiles"] == null
          ? []
          : List<MediaFile>.from(
              json["mediaFiles"]!.map((x) => MediaFile.fromJson(x))),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      likesCount: json["likeCount"],
      commentsCount: json["commentCount"],
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
