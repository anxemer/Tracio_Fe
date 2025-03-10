import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';

enum CommentMode {
  blogComment,
  replyComment,
  replyToReply
}

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

  factory CommentInputData.forReplyToComment(CommentBlogEntity comment) {
    return CommentInputData(
      mode: CommentMode.replyComment,
      commentId: comment.commentId,
      hintText: 'Reply to ${comment.userName}',
      replyToUserName: comment.userName,
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
}
