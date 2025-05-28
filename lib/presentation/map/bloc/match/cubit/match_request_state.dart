part of 'match_request_cubit.dart';

abstract class MatchRequestState extends Equatable {
  const MatchRequestState();

  @override
  List<Object?> get props => [];
}

class MatchRequestInitial extends MatchRequestState {}

class MatchRequestVisible extends MatchRequestState {
  final UserMatchingModel request;
  final int remainingSeconds;

  const MatchRequestVisible(this.request, this.remainingSeconds);

  @override
  List<Object?> get props => [request, remainingSeconds];
}

class MatchRequestHidden extends MatchRequestState {}

class MatchRequestLoading extends MatchRequestState {
  final UserMatchingModel request;
  final bool isAccepting;

  const MatchRequestLoading(this.request, this.isAccepting);

  @override
  List<Object?> get props => [request, isAccepting];
}

class MatchRequestError extends MatchRequestState {
  final String message;
  final UserMatchingModel? request;

  const MatchRequestError(this.message, [this.request]);

  @override
  List<Object?> get props => [message, request];
}
