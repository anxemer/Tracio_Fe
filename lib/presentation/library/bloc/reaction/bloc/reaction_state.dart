// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'reaction_bloc.dart';

class ReactionState extends Equatable {
  final List<int> reactRoutes;
  final List<int> reactReplies;
  final List<int> reactReviews;
  final List<int> reactBlog;
  final List<int> reactComment;
  final List<int> reactReplyComment;
  final Failure? failure;
  const ReactionState({
    this.reactRoutes = const [],
    this.reactReplies = const [],
    this.reactReviews = const [],
    this.reactBlog = const [],
    this.reactComment = const [],
    this.reactReplyComment = const [],
    this.failure,
  });

  ReactionState copyWith({
    List<int>? reactRoutes,
    List<int>? reactReplies,
    List<int>? reactReviews,
    List<int>? reactBlogs,
    List<int>? reactComment,
    List<int>? reactReplyComment,
    Failure? failure,
  }) {
    return ReactionState(
      reactRoutes: reactRoutes ?? this.reactRoutes,
      reactReplies: reactReplies ?? this.reactReplies,
      reactReviews: reactReviews ?? this.reactReviews,
      reactBlog: reactBlogs ?? this.reactBlog,
      reactComment: reactComment ?? this.reactComment,
      reactReplyComment: reactReplyComment ?? this.reactReplyComment,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props => [
        reactRoutes,
        reactReplies,
        reactReviews,
        reactBlog,
        reactComment,
        reactReplies
      ];
}
