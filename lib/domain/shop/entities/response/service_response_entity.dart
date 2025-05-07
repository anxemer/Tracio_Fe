// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:Tracio/domain/shop/entities/response/pagination_service_data_entity.dart';
import 'package:Tracio/domain/shop/entities/response/shop_entity.dart';
import 'package:Tracio/domain/shop/entities/response/shop_service_entity.dart';

class ServiceResponseEntity {
  final List<ShopEntity> shop;
  final List<ShopServiceEntity> service;
  final PaginationServiceDataEntity paginationMetaData;
  ServiceResponseEntity({
    required this.shop,
    required this.service,
    required this.paginationMetaData,
  });
}
