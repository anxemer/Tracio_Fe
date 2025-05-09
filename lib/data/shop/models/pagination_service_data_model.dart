import 'package:Tracio/domain/shop/entities/response/pagination_service_data_entity.dart';

class PaginationServiceDataModel extends PaginationServiceDataEntity {
  PaginationServiceDataModel(
      {required super.totalShops,
      required super.totalServices,
      required super.pageSizeService,
      required super.pageNumberService,
      required super.pageSizeShop,
      required super.pageNumberShop});

  factory PaginationServiceDataModel.fromJson(Map<String, dynamic> json) {
    return PaginationServiceDataModel(
      totalShops: json["totalShops"],
      totalServices: json["totalServices"],
      pageSizeService: json["pageSizeService"],
      pageNumberService: json["pageNumberService"],
      pageSizeShop: json["pageSizeShop"],
      pageNumberShop: json["pageNumberShop"],
    );
  }

  Map<String, dynamic> toJson() => {
        "totalShops": totalShops,
        "totalServices": totalServices,
        "pageSizeService": pageSizeService,
        "pageNumberService": pageNumberService,
        "pageSizeShop": pageSizeShop,
        "pageNumberShop": pageNumberShop,
      };
}
