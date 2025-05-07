

import 'package:Tracio/domain/shop/entities/request/pagination_review_data_entity.dart';
import 'package:Tracio/domain/shop/entities/response/review_service_entity.dart';

class ReviewServiceResponseEntity {
  final List<ReviewServiceEntity> reviewService;
  final PaginationReviewDataEntity paginationReviewDataEntity;
  ReviewServiceResponseEntity({
    required this.reviewService,
    required this.paginationReviewDataEntity,
  });

 

}
