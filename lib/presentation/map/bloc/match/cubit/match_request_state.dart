part of 'match_request_cubit.dart';

abstract class MatchRequestState extends Equatable {
  const MatchRequestState();

  @override
  List<Object?> get props => [];
}

class MatchRequestInitial extends MatchRequestState {}

class MatchRequestVisible extends MatchRequestState {
  final UserMatchingModel request;

  const MatchRequestVisible(this.request);

  @override
  List<Object?> get props => [request];
}

class MatchRequestHidden extends MatchRequestState {}
