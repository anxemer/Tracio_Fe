import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/data/blog/models/request/get_comment_req.dart';
import 'package:Tracio/data/blog/models/request/get_reply_comment_req.dart';
import 'package:Tracio/domain/blog/entites/comment_blog.dart';
import 'package:Tracio/domain/blog/entites/reply_comment.dart';
import 'package:Tracio/domain/blog/usecase/get_comment_blog.dart';
import 'package:Tracio/domain/blog/usecase/get_reply_comment.dart';
import 'package:Tracio/presentation/blog/bloc/comment/get_comment_state.dart';
import 'package:Tracio/service_locator.dart';

class GetCommentCubit extends Cubit<GetCommentState> {
  GetCommentCubit() : super(GetCommentInitial());

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
          totalCount: reviewsData.totalCount ?? 0,
          commentBlogPaginationEntity: reviewsData,
          pageNumber: comment.pageNumber ?? 1,
          pageSize: comment.pageSize ?? 20,
          totalPages: reviewsData.totalPage ?? 1,
          hasPreviousPage: reviewsData.hasPreviousPage ?? false,
          hasNextPage: reviewsData.hasNextPage ?? false,
        ));
      }
    });
  }

  Future<void> getCommentBlogReply(int commentId,
      {int pageNumber = 1, int pageSize = 20}) async {
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
          pageSize: 20,
          totalPages: 1,
          hasPreviousPage: false,
          hasNextPage: false,
        ));
      }
    });
  }

  void addComment(CommentBlogEntity newComment) {
    if (state is GetCommentLoaded) {
      final currentState = state as GetCommentLoaded;
      final updatedComments = [newComment, ...currentState.listComment];
      emit(currentState.copyWith(
        listComment: updatedComments,
        totalCount: currentState.totalCount + 1,
        // Cập nhật commentBlogPaginationEntity nếu cần
        commentBlogPaginationEntity:
            currentState.commentBlogPaginationEntity?.copyWith(
          comments: updatedComments,
          totalCount: currentState.totalCount + 1,
        ),
      ));
    } else {
      emit(GetCommentLoaded(
        listComment: [newComment],
        totalCount: 1,
        commentBlogPaginationEntity: null,
        pageNumber: 1,
        pageSize: 20,
        totalPages: 1,
        hasPreviousPage: false,
        hasNextPage: false,
      ));
    }
  }

  void addReplyComment(int commentId, ReplyCommentEntity newReply) {
    if (state is GetCommentLoaded) {
      final currentState = state as GetCommentLoaded;
      final updatedComments = currentState.listComment.map((comment) {
        if (comment.commentId == commentId) {
          // Chỉ định kiểu List<ReplyCommentEntity> cho danh sách rỗng
          final updatedReplies = <ReplyCommentEntity>[
            newReply,
            ...(comment.replyCommentPagination?.replies ??
                <ReplyCommentEntity>[])
          ];
          return comment.copyWith(
            replyCommentPagination: comment.replyCommentPagination?.copyWith(
                  replies: updatedReplies,
                  totalCount:
                      (comment.replyCommentPagination?.totalCount ?? 0) + 1,
                ) ??
                ReplyCommentBlogPaginationEntity(
                  comment: comment,
                  replies: updatedReplies,
                  totalCount: 1,
                  pageNumber: 1,
                  pageSize: 20,
                  totalPage: 1,
                  hasPreviousPage: false,
                  hasNextPage: false,
                ),
            replyCount: (comment.replyCount ?? 0) + 1,
          );
        }
        return comment;
      }).toList();
      emit(currentState.copyWith(
        listComment: updatedComments,
        totalCount: currentState.totalCount + 1,
        commentBlogPaginationEntity:
            currentState.commentBlogPaginationEntity?.copyWith(
          comments: updatedComments,
          totalCount: currentState.totalCount + 1,
        ),
      ));
    }
  }
}
