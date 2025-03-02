import '../../../data/blog/models/view/blog_model.dart';

class BlogEntity {
  BlogEntity({
    required this.blogId,
    required this.userId,
    required this.userName,
    required this.avatar,
    required this.privacySetting,
    required this.isReacted,
    required this.isBookmarked,
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
  int privacySetting;
  bool isReacted;
  bool isBookmarked;
  final String content;
  final List<MediaFile> mediaFiles;
  DateTime? createdAt;
  DateTime? updatedAt;
  int likesCount;
  int commentsCount;
}
