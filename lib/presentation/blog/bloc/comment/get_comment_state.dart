import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';

import '../../../../core/erorr/failure.dart';

abstract class GetCommentState {}

class GetCommentLoading extends GetCommentState {}

class GetCommentLoaded extends GetCommentState {
  final List<CommentBlogEntity> listComment;

  GetCommentLoaded({required this.listComment});
}

class GetCommentFailure extends GetCommentState {
  final Failure failure;

  GetCommentFailure(this.failure);
}
