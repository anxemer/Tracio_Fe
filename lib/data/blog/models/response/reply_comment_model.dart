import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';

import 'blog_model.dart';

class ReplyCommentModel extends ReplyCommentEntity {
  final DateTime? updatedAt;
  final bool? isEdited;
  ReplyCommentModel({
    required super.replyId,
    required super.cyclistId,
    required super.commentId,
    required super.cyclistName,
    required super.content,
    required super.isReacted,
    required super.mediaFiles,
    required super.createdAt,
    required super.likesCount,
    this.updatedAt,
    this.isEdited,
  });
  factory ReplyCommentModel.fromJson(Map<String, dynamic> json) {
    return ReplyCommentModel(
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
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: json["updatedAt"],
      likesCount: json["likesCount"],
      isEdited: json["isEdited"],
    );
  }
}
