class BlogEntity {
  BlogEntity({
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
  final dynamic tittle;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int commentsCount;
}
