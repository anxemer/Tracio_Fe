import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/blog/models/request/get_comment_req.dart';
import 'package:tracio_fe/data/blog/models/request/get_reply_comment_req.dart';
import 'package:tracio_fe/domain/blog/usecase/get_comment_blog.dart';
import 'package:tracio_fe/domain/blog/usecase/get_reply_comment.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/get_comment_state.dart';

import '../../../../service_locator.dart';

class GetCommentCubit extends Cubit<GetCommentState> {
  GetCommentCubit() : super(GetCommentInitial());

  // Future<void> getCommentBlog(GetCommentReq comment) async {
  //   emit(GetCommentLoading());
  //   var result = await sl<GetCommentBlogUseCase>().call(comment);
  //   result.fold((error) => emit(GetCommentFailure(error)),
  //       (data) => emit(GetCommentLoaded(listComment: data.comments)));

  // }

  Future<void> getCommentBlog(GetCommentReq comment) async {
    GetCommentLoaded? currentState;
    if (state is GetCommentLoaded) currentState = state as GetCommentLoaded;

    emit(GetCommentLoading());
    final params = GetCommentReq(
      blogId: comment.blogId,
      pageNumber: comment.pageNumber,
      pageSize: comment.pageSize,
    );

    var data = await sl<GetCommentBlogUseCase>().call(params);

    data.fold((error) {
      emit(GetCommentFailure(error));
    }, (reviewsData) {
      if (currentState != null) {
        emit(currentState.copyWith(
          listComment: reviewsData.comments,
          commentBlogPaginationEntity: reviewsData,
        ));
        Future.wait([]);
      } else {
        emit(GetCommentLoaded(
          listComment: reviewsData.comments,
          totalCount: 0,
          commentBlogPaginationEntity: reviewsData,
          pageNumber: 1,
          pageSize: 5,
          totalPages: 1,
          hasPreviousPage: false,
          hasNextPage: false,
        ));
      }
    });
  }

  Future<void> getCommentBlogReply(int commentId,
      {int pageNumber = 1, int pageSize = 5}) async {
    GetCommentLoaded? currentState;
    if (state is GetCommentLoaded) currentState = state as GetCommentLoaded;

    final params = GetReplyCommentReq(
      commentId: commentId,
      replyId: null,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );

    var data = await sl<GetReplyCommentUsecase>().call(params);

    data.fold((error) {
      emit(GetCommentFailure(error));
    }, (repliesData) {
      if (currentState != null) {
        final updatedReviews = currentState.listComment.map((comment) {
          if (comment.commentId == commentId) {
            return comment.copyWith(
              replyCommentPagination: repliesData,
            );
          }
          return comment;
        }).toList();
        emit(currentState.copyWith(
          listComment: updatedReviews,
        ));
      } else {
        emit(GetCommentLoaded(
          listComment: [],
          totalCount: 0,
          commentBlogPaginationEntity: null,
          pageNumber: 1,
          pageSize: 5,
          totalPages: 1,
          hasPreviousPage: false,
          hasNextPage: false,
        ));
      }
    });
  }
}
