import 'package:Tracio/domain/blog/entites/comment_blog.dart';
import 'package:Tracio/domain/blog/entites/reply_comment.dart';
import 'package:Tracio/domain/shop/entities/response/reply_review_entity.dart';

import '../../map/entities/route_reply.dart';
import '../../map/entities/route_review.dart';

enum CommentMode { blogComment, replyComment, replyToReply }

class CommentInputData {
  final CommentMode mode;
  final int? blogId;
  final int? commentId;
  final int? replyId;
  final String hintText;
  final String? replyToUserName;

  CommentInputData({
    this.mode = CommentMode.blogComment,
    this.blogId,
    this.commentId,
    this.replyId,
    this.hintText = 'Add a comment',
    this.replyToUserName,
  });

  factory CommentInputData.forBlog(int blogId) {
    return CommentInputData(
      mode: CommentMode.blogComment,
      blogId: blogId,
      hintText: 'Add a comment',
    );
  }
  factory CommentInputData.forRoute(int routeId) {
    return CommentInputData(
      mode: CommentMode.blogComment,
      blogId: routeId,
      hintText: 'Add a Review',
    );
  }

  factory CommentInputData.forReplyToComment(CommentBlogEntity comment) {
    return CommentInputData(
      mode: CommentMode.replyComment,
      commentId: comment.commentId,
      hintText: 'Reply to ${comment.userName}',
      replyToUserName: comment.userName,
    );
  }
  factory CommentInputData.forReplyToReview(RouteReviewEntity review) {
    return CommentInputData(
      mode: CommentMode.replyComment,
      commentId: review.commentId,
      hintText: 'Reply to ${review.userName}',
      replyToUserName: review.userName,
    );
  }

  factory CommentInputData.forReplyToReply(ReplyCommentEntity reply) {
    return CommentInputData(
      mode: CommentMode.replyToReply,
      commentId: reply.commentId,
      replyId: reply.replyId,
      hintText: 'Reply to ${reply.cyclistName}',
      replyToUserName: reply.cyclistName,
    );
  }
  factory CommentInputData.forReplyToReplyRoute(RouteReplyEntity reply) {
    return CommentInputData(
      mode: CommentMode.replyToReply,
      commentId: reply.reviewId,
      replyId: reply.replyId,
      hintText: 'Reply to ${reply.cyclistName}',
      replyToUserName: reply.cyclistName,
    );
  }
}
