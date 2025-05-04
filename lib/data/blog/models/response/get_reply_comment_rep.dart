import 'package:tracio_fe/data/blog/models/response/comment_blog_model.dart';
import 'package:tracio_fe/data/blog/models/response/reply_comment_model.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';

class GetReplyCommentRepMode extends ReplyCommentBlogPaginationEntity {
  GetReplyCommentRepMode(
      {required super.replies,
      required super.totalCount,
      required super.pageNumber,
      required super.pageSize,
      required super.totalPage,
      required super.hasPreviousPage,
      required super.hasNextPage,
      required super.comment});

  factory GetReplyCommentRepMode.fromMap(Map<String, dynamic> map) {
    return GetReplyCommentRepMode(
      replies: List<ReplyCommentModel>.from(
        (map['replies']).map<ReplyCommentModel>(
          (x) => ReplyCommentModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
      totalCount: map['totalReply'] as int,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalPage: map['totalPage'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
      comment: CommentBlogModel.fromMap(map['comment']),
    );
  }
}
