// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../common/helper/media_file.dart';
import '../../../data/blog/models/response/blog_model.dart';

class ReplyCommentEntity {
  final int replyId;
  final int cyclistId;
  final int commentId;
  final String cyclistName;
  final String content;
  bool isReacted;
  final List<MediaFile> mediaFiles;
  final DateTime? createdAt;
  int likesCount;
  ReplyCommentEntity({
    required this.replyId,
    required this.cyclistId,
    required this.commentId,
    required this.cyclistName,
    required this.content,
    required this.isReacted,
    required this.mediaFiles,
    required this.createdAt,
    required this.likesCount,
  });
}
