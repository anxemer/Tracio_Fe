import 'package:Tracio/data/blog/models/response/reply_comment_model.dart';
import 'package:Tracio/data/shop/models/pagination_review_data_model.dart';
import 'package:Tracio/data/shop/models/reply_review_model.dart';
import 'package:Tracio/data/shop/models/review_service_model.dart';
import 'package:Tracio/domain/shop/entities/response/review_service_response_entity.dart';

class ReviewServiceResponseModel extends ReviewServiceResponseEntity {
  ReviewServiceResponseModel({
    required super.reviewService,
    required super.paginationReviewDataEntity,
  });

  factory ReviewServiceResponseModel.fromMap(Map<String, dynamic> map) {
    final resultMap = map['result'];
    // if (resultMap == null) {
    //   throw FormatException("Missing 'result' field in API response");
    // }

    final List<dynamic> reviewServiceList = resultMap['reviews'] ?? [];

    return ReviewServiceResponseModel(
      reviewService: List<ReviewServiceModel>.from(
        reviewServiceList.map(
          (x) => ReviewServiceModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
      paginationReviewDataEntity: PaginationReviewDataModel.fromMap(
        resultMap as Map<String, dynamic>,
      ),
    );
  }
}
