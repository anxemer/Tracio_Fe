part of 'service_detail_cubit.dart';

sealed class ServiceDetailState extends Equatable {
  const ServiceDetailState();

  @override
  List<Object> get props => [];
}

final class ServiceDetailInitial extends ServiceDetailState {}

final class ServiceDetailLoading extends ServiceDetailState {}

final class ServiceDetailLoaded extends ServiceDetailState {
  final DetailServiceResponseEntity detailService;

  const ServiceDetailLoaded(this.detailService);
}

final class ServiceDetailFailure extends ServiceDetailState {
  final String message;
  final Failure failure;

  const ServiceDetailFailure(this.message, this.failure);
}
