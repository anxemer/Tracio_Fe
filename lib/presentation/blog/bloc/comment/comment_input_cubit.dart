// comment_input_cubit.dart
import 'package:Tracio/domain/map/entities/route_reply.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/blog/entites/comment_blog.dart';
import '../../../../domain/blog/entites/comment_input_data.dart';
import '../../../../domain/blog/entites/reply_comment.dart';
import '../../../../domain/map/entities/route_review.dart';
import 'comment_input_state.dart';

class CommentInputCubit extends Cubit<CommentInputState> {
  CommentInputCubit._(CommentInputData data)
      : super(CommentInputState(inputData: data));

  // Dùng cho blog
  factory CommentInputCubit.forBlog(int blogId) {
    return CommentInputCubit._(CommentInputData.forBlog(blogId));
  }

  // Dùng cho route
  factory CommentInputCubit.forRoute(int routeId) {
    return CommentInputCubit._(CommentInputData.forRoute(routeId));
  }

  void updateToDefault(int blogId) {
    emit(CommentInputState(
      inputData: CommentInputData.forBlog(blogId),
    ));
  }

  void updateToDefaultRoute(int routeId) {
    emit(CommentInputState(
      inputData: CommentInputData.forRoute(routeId),
    ));
  }

  void updateToReplyComment(CommentBlogEntity comment) {
    emit(CommentInputState(
      inputData: CommentInputData.forReplyToComment(comment),
    ));
  }

  void updateToReplyReview(RouteReviewEntity review) {
    emit(CommentInputState(
      inputData: CommentInputData.forReplyToReview(review),
    ));
  }

  void updateToReplyToReply(ReplyCommentEntity reply) {
    emit(CommentInputState(
      inputData: CommentInputData.forReplyToReply(reply),
    ));
  }

  void updateToReplyToReplyRoute(RouteReplyEntity reply) {
    emit(CommentInputState(
      inputData: CommentInputData.forReplyToReplyRoute(reply),
    ));
  }
}
