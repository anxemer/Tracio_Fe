import 'package:equatable/equatable.dart';
import 'package:Tracio/domain/shop/entities/response/pagination_service_data_entity.dart';
import 'package:Tracio/domain/shop/entities/response/shop_entity.dart';

import '../../../../data/shop/models/get_service_req.dart';
import '../../../../domain/shop/entities/response/shop_service_entity.dart';

abstract class GetServiceState extends Equatable {
  const GetServiceState(this.service, this.shop, this.metaData, this.params);
  final List<ShopServiceEntity> service;
  final List<ShopEntity> shop;
  final PaginationServiceDataEntity metaData;
  final GetServiceReq params;
  @override
  List<Object> get props => [];
}

final class GetServiceInitial extends GetServiceState {
  const GetServiceInitial(
      super.service, super.shop, super.metaData, super.params);

  @override
  List<Object> get props => [];
}

final class GetServiceLoading extends GetServiceState {
  const GetServiceLoading(
      super.service, super.metaData, super.params, super.shop);
  @override
  List<Object> get props => [];
}

final class GetServiceLoaded extends GetServiceState {
  const GetServiceLoaded(
      super.service, super.shop, super.metaData, super.params);
  @override
  List<Object> get props => [service, shop];
}

final class GetServiceFailure extends GetServiceState {
  final String message;
  const GetServiceFailure(
      super.service, super.metaData, super.params, super.shop, this.message);

  @override
  List<Object> get props => [];
}
