// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../../../common/helper/media_file.dart';

class ReplyCommentEntity {
  final int replyId;
  final int cyclistId;
  final int commentId;
  final int? reReplyCyclistId;
  final String cyclistName;
  final String? reReplyCyclistName;
  final String content;
  bool isReacted;
  final List<MediaFile> mediaFiles;
  final DateTime? createdAt;
  int likesCount;
  ReplyCommentEntity({
    required this.replyId,
    required this.cyclistId,
    required this.commentId,
    this.reReplyCyclistId,
    required this.cyclistName,
    required this.reReplyCyclistName,
    required this.content,
    required this.isReacted,
    required this.mediaFiles,
    required this.createdAt,
    required this.likesCount,
  });
}
