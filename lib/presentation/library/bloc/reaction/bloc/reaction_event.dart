part of 'reaction_bloc.dart';

sealed class ReactionEvent extends Equatable {
  const ReactionEvent();

  @override
  List<Object> get props => [];
}

class InitializeReactionRoute extends ReactionEvent {
  final RouteBlogEntity route;
  const InitializeReactionRoute({required this.route});

  @override
  List<Object> get props => [route];
}

final class ReactRoute extends ReactionEvent {
  final int routeId;
  const ReactRoute({required this.routeId});

  @override
  List<Object> get props => [routeId];
}

final class ReactReview extends ReactionEvent {
  final int reviewId;
  const ReactReview({required this.reviewId});

  @override
  List<Object> get props => [reviewId];
}

final class ReactReply extends ReactionEvent {
  final int replyId;
  const ReactReply({required this.replyId});

  @override
  List<Object> get props => [replyId];
}

final class UnReactReply extends ReactionEvent {
  final int replyId;
  const UnReactReply({required this.replyId});

  @override
  List<Object> get props => [replyId];
}

final class UnReactReview extends ReactionEvent {
  final int reviewId;
  const UnReactReview({required this.reviewId});

  @override
  List<Object> get props => [reviewId];
}

final class UnReactRoute extends ReactionEvent {
  final int routeId;
  const UnReactRoute({required this.routeId});

  @override
  List<Object> get props => [routeId];
}
