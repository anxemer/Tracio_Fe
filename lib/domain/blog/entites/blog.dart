import 'dart:io';

import '../../../data/blog/models/blog.dart';

class BlogEntity {
  BlogEntity({
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
  bool isReacted;
  final int reactionId;
  final String content;
  final List<MediaFile> mediaFiles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int likesCount;
  final int commentsCount;
}
