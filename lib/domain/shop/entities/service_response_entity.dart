// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:tracio_fe/domain/shop/entities/shop_entity.dart';
import 'package:tracio_fe/domain/shop/entities/shop_service_entity.dart';

class ServiceResponseEntity {
  final List<ShopEntity> shop;
  final List<ShopServiceEntity> service;
  ServiceResponseEntity({
    required this.shop,
    required this.service,
  });
}
