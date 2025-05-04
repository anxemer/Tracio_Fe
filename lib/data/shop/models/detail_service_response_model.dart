import 'package:tracio_fe/data/shop/models/review_service_model.dart';
import 'package:tracio_fe/data/shop/models/shop_service_model.dart';
import 'package:tracio_fe/domain/shop/entities/response/detail_service_response_entity.dart';

class DetailServiceResponseModel extends DetailServiceResponseEntity {
  DetailServiceResponseModel(
      {required super.service, required super.reviewService});

  //       Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'service': service.toMap(),
  //     'reviewService': reviewService.toMap(),
  //   };
  // }

  factory DetailServiceResponseModel.fromMap(Map<String, dynamic> map) {
    final serviceMap = map['service'] as Map<String, dynamic>;
    return DetailServiceResponseModel(
      service: ShopServiceModel.fromMap(serviceMap),
      reviewService: serviceMap['reviews'] != null
          ? List<ReviewServiceModel>.from(
              serviceMap['reviews'].map(
                (x) => ReviewServiceModel.fromJson(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }
}
