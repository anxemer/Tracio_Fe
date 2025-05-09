import 'package:Tracio/domain/shop/entities/response/review_service_entity.dart';
import 'package:Tracio/domain/shop/entities/response/shop_service_entity.dart';

class DetailServiceResponseEntity {
  final ShopServiceEntity service;
  final List<ReviewServiceEntity> reviewService;
  DetailServiceResponseEntity({
    required this.service,
    required this.reviewService,
  });
}
