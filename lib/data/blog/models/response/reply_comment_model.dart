import 'package:Tracio/domain/blog/entites/reply_comment.dart';

import '../../../../common/helper/media_file.dart';

class ReplyCommentModel extends ReplyCommentEntity {
  final bool? isEdited;
  ReplyCommentModel({
    required super.replyId,
    required super.cyclistId,
    required super.commentId,
    required super.cyclistName,
    super.reReplyCyclistId,
    super.reReplyCyclistName,
    required super.content,
    required super.isReacted,
    required super.mediaFiles,
    required super.createdAt,
    this.isEdited,
    required super.tagUserNames,
    required super.mediaUrls,
    required super.likeCount,
    required super.replyCount,
  });
  factory ReplyCommentModel.fromJson(Map<String, dynamic> json) {
    return ReplyCommentModel(
      reReplyCyclistId: json['reReplyCyclistId'] != null
          ? json['reReplyCyclistId'] as int
          : null,
      reReplyCyclistName: json['reReplyCyclistName'] != null
          ? json['reReplyCyclistName'] as String
          : null,
      replyId: json["replyId"],
      cyclistId: json["cyclistId"],
      commentId: json["commentId"],
      cyclistName: json["cyclistName"],
      content: json["content"],
      isReacted: json["isReacted"],
      mediaFiles: json["mediaFiles"] == null
          ? []
          : List<MediaFile>.from(
              json["mediaFiles"]!.map((x) => MediaFile.fromJson(x))),
      createdAt: DateTime.parse(json['createdAt']),
      isEdited: json["isEdited"],
      tagUserNames: [],
      mediaUrls: [],
      likeCount: json["likeCount"],
      replyCount: 0,
    );
  }
}
