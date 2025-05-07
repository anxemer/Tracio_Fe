import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/blog/models/request/react_blog_req.dart';
import 'package:Tracio/domain/blog/entites/blog_entity.dart';
import 'package:Tracio/domain/blog/usecase/react_blog.dart';
import 'package:Tracio/domain/blog/usecase/un_react_blog.dart';
import 'package:Tracio/domain/map/entities/route_blog.dart';
import 'package:Tracio/domain/map/usecase/reaction/delete_reaction_reply_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/delete_reaction_review_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/delete_reaction_route_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/post_reaction_reply_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/post_reaction_review_usecase.dart';
import 'package:Tracio/domain/map/usecase/reaction/post_reaction_route_usecase.dart';
import 'package:Tracio/service_locator.dart';

part 'reaction_event.dart';
part 'reaction_state.dart';

class ReactionBloc extends Bloc<ReactionEvent, ReactionState> {
  ReactionBloc() : super(ReactionState()) {
    on<InitializeReactionRoute>(_onInitializeReactionRoute);
    on<InitializeReactionBlog>(_onInitializeReactionBlog);
    on<ReactRoute>(_onReactRoute);
    on<ReactReview>(_onReactReview);
    on<ReactReply>(_onReactReply);
    on<ReactionBlog>(_onReactBlog);
    on<ReactComment>(_onReactComment);
    on<ReactReplyComment>(_onReactReplyComment);
    on<UnReactRoute>(_onUnReactRoute);
    on<UnReactReview>(_onUnReactReview);
    on<UnReactReply>(_onUnReactReply);
    on<UnReactBlog>(_onUnReactBlog);
    on<UnReactComment>(_onUnReactComment);
    on<UnReactReplyComment>(_onUnReactReplyComment);
  }

  Future<void> _onInitializeReactionRoute(
      InitializeReactionRoute event, Emitter<ReactionState> emit) async {
    final route = event.route;

    final newReactRoutes = List<int>.from(state.reactRoutes);

    if (route.isReacted) {
      newReactRoutes.add(route.routeId);
    }

    emit(state.copyWith(reactRoutes: newReactRoutes));
  }

  FutureOr<void> _onInitializeReactionBlog(
      InitializeReactionBlog event, Emitter<ReactionState> emit) {
    final blog = event.blog;

    final newReactBlog = List<int>.from(state.reactBlog);

    if (blog.isReacted) {
      newReactBlog.add(blog.blogId);
    }

    emit(state.copyWith(reactBlogs: newReactBlog));
  }

  Future<void> _onReactRoute(
      ReactRoute event, Emitter<ReactionState> emit) async {
    final newReactRoutes = List<int>.from(state.reactRoutes);

    // Add the route ID if not already present
    _addOrUpdateReaction(newReactRoutes, event.routeId, true);
    emit(state.copyWith(reactRoutes: newReactRoutes));

    final postReactionResult = await _postReactionWithRetry(
      () => sl<PostReactionRouteUsecase>().call(event.routeId),
    );

    emit(postReactionResult.fold(
      (failure) =>
          state.copyWith(reactRoutes: newReactRoutes, failure: failure),
      (response) => state.copyWith(reactRoutes: newReactRoutes),
    ));
  }

  Future<void> _onReactReview(
      ReactReview event, Emitter<ReactionState> emit) async {
    final newReactReviews = List<int>.from(state.reactReviews);

    // Add the review ID if not already present
    _addOrUpdateReaction(newReactReviews, event.reviewId, true);
    emit(state.copyWith(reactReviews: newReactReviews));

    final postReactionResult = await _postReactionWithRetry(
      () => sl<PostReactionReviewUsecase>().call(event.reviewId),
    );

    emit(postReactionResult.fold(
      (failure) =>
          state.copyWith(reactReviews: newReactReviews, failure: failure),
      (response) => state.copyWith(reactReviews: newReactReviews),
    ));
  }

  Future<void> _onReactReply(
      ReactReply event, Emitter<ReactionState> emit) async {
    final newReactReplies = List<int>.from(state.reactReplies);

    // Add the reply ID if not already present
    _addOrUpdateReaction(newReactReplies, event.replyId, true);
    emit(state.copyWith(reactReplies: newReactReplies));

    final postReactionResult = await _postReactionWithRetry(
      () => sl<PostReactionReplyUsecase>().call(event.replyId),
    );

    emit(postReactionResult.fold(
      (failure) =>
          state.copyWith(reactReplies: newReactReplies, failure: failure),
      (response) => state.copyWith(reactReplies: newReactReplies),
    ));
  }

  Future<void> _onUnReactRoute(
      UnReactRoute event, Emitter<ReactionState> emit) async {
    final newReactRoutes = List<int>.from(state.reactRoutes);

    // Remove the route ID if exists
    _removeReaction(newReactRoutes, event.routeId);
    emit(state.copyWith(reactRoutes: newReactRoutes));

    final deleteReactionResult = await _postReactionWithRetry(
      () => sl<DeleteReactionRouteUsecase>().call(event.routeId),
    );

    emit(deleteReactionResult.fold(
      (failure) =>
          state.copyWith(reactRoutes: newReactRoutes, failure: failure),
      (response) => state.copyWith(reactRoutes: newReactRoutes),
    ));
  }

  Future<void> _onUnReactReview(
      UnReactReview event, Emitter<ReactionState> emit) async {
    final newReactReviews = List<int>.from(state.reactReviews);

    // Remove the review ID if exists
    _removeReaction(newReactReviews, event.reviewId);
    emit(state.copyWith(reactReviews: newReactReviews));

    final deleteReactionResult = await _postReactionWithRetry(
      () => sl<DeleteReactionReviewUsecase>().call(event.reviewId),
    );

    emit(deleteReactionResult.fold(
      (failure) =>
          state.copyWith(reactReviews: newReactReviews, failure: failure),
      (response) => state.copyWith(reactReviews: newReactReviews),
    ));
  }

  Future<void> _onUnReactReply(
      UnReactReply event, Emitter<ReactionState> emit) async {
    final newReactReplies = List<int>.from(state.reactReplies);

    // Remove the reply ID if exists
    _removeReaction(newReactReplies, event.replyId);
    emit(state.copyWith(reactReplies: newReactReplies));

    final deleteReactionResult = await _postReactionWithRetry(
      () => sl<DeleteReactionReplyUsecase>().call(event.replyId),
    );

    emit(deleteReactionResult.fold(
      (failure) =>
          state.copyWith(reactReplies: newReactReplies, failure: failure),
      (response) => state.copyWith(reactReplies: newReactReplies),
    ));
  }

  void _addOrUpdateReaction(List<int> list, int id, bool isReacted) {
    if (list.contains(id)) {
      // If the id already exists, update the list element to reflect the reaction status
      int index = list.indexOf(id);
      list[index] = isReacted ? id : list[index];
    } else {
      // If the id does not exist, add it to the list
      list.add(id);
    }
  }

  // Helper method to remove reaction from the list
  void _removeReaction(List<int> list, int id) {
    list.remove(id);
  }

  // Common retry logic for API calls
  Future<Either<Failure, dynamic>> _postReactionWithRetry(
    Future<Either<Failure, dynamic>> Function() apiCall,
  ) async {
    int retryCount = 0;
    const int maxRetries = 3;
    const Duration retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      final result = await apiCall();
      if (result.isRight()) {
        return result;
      } else {
        retryCount++;
        if (retryCount < maxRetries) {
          await Future.delayed(retryDelay);
        }
      }
    }
    return Left(ExceptionFailure("Failed after $maxRetries attempts"));
  }

  FutureOr<void> _onReactBlog(
      ReactionBlog event, Emitter<ReactionState> emit) async {
    final newReactblog = List<int>.from(state.reactBlog);
    // Add the reply ID if not already present
    _addOrUpdateReaction(newReactblog, event.blogId, true);
    emit(state.copyWith(reactBlogs: newReactblog));

    final postReactionResult = await _postReactionWithRetry(
      () => sl<ReactBlogUseCase>()
          .call(ReactBlogReq(entityId: event.blogId, entityType: 'blog')),
    );

    emit(postReactionResult.fold(
      (failure) => state.copyWith(reactReplies: newReactblog, failure: failure),
      (response) => state.copyWith(reactReplies: newReactblog),
    ));
  }

  FutureOr<void> _onReactComment(
      ReactComment event, Emitter<ReactionState> emit) async {
    final newReactComment = List<int>.from(state.reactComment);
    // Add the reply ID if not already present
    _addOrUpdateReaction(newReactComment, event.commentId, true);
    emit(state.copyWith(reactBlogs: newReactComment));

    final postReactionResult = await _postReactionWithRetry(
      () => sl<ReactBlogUseCase>()
          .call(ReactBlogReq(entityId: event.commentId, entityType: 'comment')),
    );

    emit(postReactionResult.fold(
      (failure) =>
          state.copyWith(reactReplies: newReactComment, failure: failure),
      (response) => state.copyWith(reactReplies: newReactComment),
    ));
  }

  FutureOr<void> _onReactReplyComment(
      ReactReplyComment event, Emitter<ReactionState> emit) async {
    final newReactCReplyomment = List<int>.from(state.reactReplyComment);
    // Add the reply ID if not already present
    _addOrUpdateReaction(newReactCReplyomment, event.replyCommentId, true);
    emit(state.copyWith(reactBlogs: newReactCReplyomment));

    final postReactionResult = await _postReactionWithRetry(
      () => sl<ReactBlogUseCase>().call(
          ReactBlogReq(entityId: event.replyCommentId, entityType: 'reply')),
    );

    emit(postReactionResult.fold(
      (failure) =>
          state.copyWith(reactReplies: newReactCReplyomment, failure: failure),
      (response) => state.copyWith(reactReplies: newReactCReplyomment),
    ));
  }

  FutureOr<void> _onUnReactBlog(
      UnReactBlog event, Emitter<ReactionState> emit) async {
    final newReactBlog = List<int>.from(state.reactBlog);

    // Remove the reply ID if exists
    _removeReaction(newReactBlog, event.blogId);
    emit(state.copyWith(reactReplies: newReactBlog));

    final deleteReactionResult = await _postReactionWithRetry(
      () => sl<UnReactBlogUseCase>()
          .call(UnReactionParam(id: event.blogId, type: 'blog')),
    );

    emit(deleteReactionResult.fold(
      (failure) => state.copyWith(reactReplies: newReactBlog, failure: failure),
      (response) => state.copyWith(reactReplies: newReactBlog),
    ));
  }

  FutureOr<void> _onUnReactComment(
      UnReactComment event, Emitter<ReactionState> emit) async {
    final newReactComment = List<int>.from(state.reactComment);

    // Remove the reply ID if exists
    _removeReaction(newReactComment, event.commentId);
    emit(state.copyWith(reactReplies: newReactComment));

    final deleteReactionResult = await _postReactionWithRetry(
      () => sl<UnReactBlogUseCase>()
          .call(UnReactionParam(id: event.commentId, type: 'comment')),
    );

    emit(deleteReactionResult.fold(
      (failure) =>
          state.copyWith(reactReplies: newReactComment, failure: failure),
      (response) => state.copyWith(reactReplies: newReactComment),
    ));
  }

  FutureOr<void> _onUnReactReplyComment(
      UnReactReplyComment event, Emitter<ReactionState> emit) async {
    final newReactReplyComment = List<int>.from(state.reactReplyComment);

    // Remove the reply ID if exists
    _removeReaction(newReactReplyComment, event.replyCommentId);
    emit(state.copyWith(reactReplies: newReactReplyComment));

    final deleteReactionResult = await _postReactionWithRetry(
      () => sl<UnReactBlogUseCase>()
          .call(UnReactionParam(id: event.replyCommentId, type: 'reply')),
    );

    emit(deleteReactionResult.fold(
      (failure) =>
          state.copyWith(reactReplies: newReactReplyComment, failure: failure),
      (response) => state.copyWith(reactReplies: newReactReplyComment),
    ));
  }
}
