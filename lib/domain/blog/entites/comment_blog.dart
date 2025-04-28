// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../common/helper/media_file.dart';

class CommentBlogEntity {
  final int? commentId;
  final int? userId;
  final String? userName;
  final String? avatar;
  final String? content;
  final DateTime? createdAt;
  final List<MediaFile> mediaFiles;

  int likesCount;
  int repliesCount;
  bool isReacted;
  CommentBlogEntity({
    this.commentId,
    this.userId,
    this.userName,
    this.avatar,
    this.content,
    this.createdAt,
    required this.mediaFiles,
    required this.likesCount,
    required this.repliesCount,
    required this.isReacted,
  });
}
