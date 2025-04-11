part of 'resolve_overlap_service_cubit.dart';

abstract class ResolveOverlapServiceState extends Equatable {
  const ResolveOverlapServiceState();

  @override
  List<Object> get props => [];
}

class ResolveOverlapServiceInitial extends ResolveOverlapServiceState {}

class ResolveOverlapServiceUpdated extends ResolveOverlapServiceState {
  final Map<int, OverlapActionStatus> statusMap;

  const ResolveOverlapServiceUpdated(this.statusMap);

  @override
  List<Object> get props => [statusMap];
}
