import 'package:tracio_fe/data/shop/models/shop_model.dart';
import 'package:tracio_fe/data/shop/models/shop_service_model.dart';
import 'package:tracio_fe/domain/shop/entities/service_response_entity.dart';

import '../../../domain/shop/entities/shop_entity.dart';
import '../../../domain/shop/entities/shop_service_entity.dart';

class ServiceResponseModel extends ServiceResponseEntity {
  ServiceResponseModel(
      {required List<ShopEntity> shop,
      required List<ShopServiceEntity> service})
      : super(shop: shop, service: service);
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'shops': (shop as ShopModel).toJson(),
      'services': (service as ShopServiceModel).toMap(),
    };
  }

  factory ServiceResponseModel.fromMap(Map<String, dynamic> map) {
    return ServiceResponseModel(
      shop: List<ShopModel>.from(map['shops']
          .map((x) => ShopModel.fromJson(x as Map<String, dynamic>))),
      service: List<ShopServiceModel>.from(map['services']
          .map((x) => ShopServiceModel.fromMap(x as Map<String, dynamic>))),
    );
  }
}
