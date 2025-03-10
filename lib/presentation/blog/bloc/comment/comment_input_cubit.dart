// comment_input_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/blog/entites/comment_blog.dart';
import '../../../../domain/blog/entites/comment_input_data.dart';
import '../../../../domain/blog/entites/reply_comment.dart';
import 'comment_input_state.dart';

class CommentInputCubit extends Cubit<CommentInputState> {
  CommentInputCubit(int blogId)
      : super(CommentInputState(
          inputData: CommentInputData.forBlog(blogId),
        ));

  void updateToDefault(int blogId) {
    emit(CommentInputState(
      inputData: CommentInputData.forBlog(blogId),
    ));
  }

  void updateToReplyComment(CommentBlogEntity comment) {
    emit(CommentInputState(
      inputData: CommentInputData.forReplyToComment(comment),
    ));
  }

  void updateToReplyToReply(ReplyCommentEntity reply) {
    emit(CommentInputState(
      inputData: CommentInputData.forReplyToReply(reply),
    ));
  }
}
