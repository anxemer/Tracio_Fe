import '../../../common/helper/media_file.dart';
import '../../../data/blog/models/response/blog_model.dart';

class BlogEntity {
  BlogEntity({
    required this.blogId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.isPublic,
    required this.isReacted,
    required this.isBookmarked,
    required this.isFollowed,
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
  bool isPublic;
  bool isReacted;
  bool isBookmarked;
  bool isFollowed;
  final String content;
  final List<MediaFile> mediaFiles;
  DateTime? createdAt;
  DateTime? updatedAt;
  int likesCount;
  int commentsCount;

  BlogEntity copyWith({
    int? blogId,
    int? userId,
    String? userName,
    String? avatar,
    int? privacySetting,
    bool? isReacted,
    bool? isBookmarked,
    String? content,
    List<MediaFile>? mediaFiles,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? commentsCount,
  }) {
    return BlogEntity(
      blogId: blogId ?? this.blogId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      avatar: avatar ?? this.avatar,
      isPublic: isPublic,
      isReacted: isReacted ?? this.isReacted,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      content: content ?? this.content,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      isFollowed: isFollowed ,
    );
  }
}
