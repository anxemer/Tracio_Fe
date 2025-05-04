import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';

import '../../../../core/erorr/failure.dart';

abstract class GetCommentState {}

class GetCommentLoading extends GetCommentState {}

class GetCommentInitial extends GetCommentState {}

class GetCommentLoaded extends GetCommentState {
  final List<CommentBlogEntity> listComment;
  final CommentBlogPaginationEntity? commentBlogPaginationEntity;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;
  GetCommentLoaded({
    required this.listComment,
    this.commentBlogPaginationEntity,
    required this.totalCount,
    this.pageNumber = 1,
    this.pageSize = 5,
    this.totalPages = 1,
    this.hasPreviousPage = false,
    this.hasNextPage = false,
  });

  GetCommentLoaded copyWith({
    List<CommentBlogEntity>? listComment,
    CommentBlogPaginationEntity? commentBlogPaginationEntity,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPages,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return GetCommentLoaded(
      listComment: listComment ?? this.listComment,
      commentBlogPaginationEntity:
          commentBlogPaginationEntity ?? this.commentBlogPaginationEntity,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}

class GetCommentFailure extends GetCommentState {
  final Failure failure;

  GetCommentFailure(this.failure);
}
