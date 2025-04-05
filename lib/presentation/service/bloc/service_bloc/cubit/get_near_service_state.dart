part of 'get_near_service_cubit.dart';

sealed class GetNearServiceState extends Equatable {
  const GetNearServiceState(this.service, this.shop);
  final List<ShopServiceEntity> service;
  final List<ShopEntity> shop;
  @override
  List<Object> get props => [];
}

final class GetNearServiceInitial extends GetNearServiceState {
  const GetNearServiceInitial(super.service, super.shop);
  @override
  List<Object> get props => [];
}

final class GetNearServiceLoading extends GetNearServiceState {
  const GetNearServiceLoading(super.service, super.shop);
  @override
  List<Object> get props => [];
}

final class GetNearServiceLoaded extends GetNearServiceState {
  const GetNearServiceLoaded(super.service, super.shop);
  @override
  List<Object> get props => [service, shop];
}

final class GetNearServiceFailure extends GetNearServiceState {
  const GetNearServiceFailure(super.service, this.message, super.shop);
  final String message;
  @override
  List<Object> get props => [];
}
