import 'package:Tracio/data/shop/models/pagination_service_data_model.dart';
import 'package:Tracio/data/shop/models/shop_model.dart';
import 'package:Tracio/data/shop/models/shop_service_model.dart';
import 'package:Tracio/domain/shop/entities/response/pagination_service_data_entity.dart';
import 'package:Tracio/domain/shop/entities/response/service_response_entity.dart';

import '../../../domain/shop/entities/response/shop_entity.dart';
import '../../../domain/shop/entities/response/shop_service_entity.dart';

class ServiceResponseModel extends ServiceResponseEntity {
  ServiceResponseModel(
      {required List<ShopEntity> shop,
      required List<ShopServiceEntity> service,
      required PaginationServiceDataEntity pagination})
      : super(shop: shop, service: service, paginationMetaData: pagination);
  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'shops': (shop as ShopModel).toJson(),
  //     'services': (service as ShopServiceModel).toMap(),
  //   };
  // }

  factory ServiceResponseModel.fromMap(Map<String, dynamic> map) {
    //  final metaData = PaginationServiceDataModel(
    //   pageNumberService:map[] ,
    //   pageNumberShop: ,
    //   pageSizeService: ,
    //   pageSizeShop: ,
    //   totalServices: ,
    //   totalShops: ,

    //   totalBlogs: map['totalBlogs'],
    //   pageNumber: map['pageNumber'] ?? 1,
    //   pageSize: map['pageSize'] ?? 5,
    //   totalPages: map['totalPages'] ?? 1,
    // );
    return ServiceResponseModel(
      shop: map['shops'] != null
          ? List<ShopModel>.from(map['shops']
              .map((x) => ShopModel.fromJson(x as Map<String, dynamic>)))
          : [],
      service: map['services'] != null
          ? List<ShopServiceModel>.from(map['services']
              .map((x) => ShopServiceModel.fromMap(x as Map<String, dynamic>)))
          : [],
      pagination: PaginationServiceDataModel.fromJson(map),
    );
  }
}
// ignore_for_file: public_member_api_docs, sort_constructors_first
