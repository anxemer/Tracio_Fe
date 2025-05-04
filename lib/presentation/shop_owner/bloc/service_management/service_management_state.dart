part of 'service_management_cubit.dart';

sealed class ServiceManagementState extends Equatable {
  const ServiceManagementState();

  @override
  List<Object> get props => [];
}

final class ServiceManagementInitial extends ServiceManagementState {}

final class CreateServiceLoading extends ServiceManagementState {}

final class CreateServiceSuccess extends ServiceManagementState {}

final class CreateServiceFailure extends ServiceManagementState {
  
  final String message;
  final Failure failure;

  const CreateServiceFailure(this.message, this.failure);
}