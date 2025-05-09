import '../../../domain/shop/entities/request/pagination_review_data_entity.dart';

class PaginationReviewDataModel extends PaginationReviewDataEntity {
  PaginationReviewDataModel({
    required super.totalComments,
    required super.pageNumber,
    required super.pageSize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalComments': totalComments,
      'pageSize': pageSize,
      'pageNumber': pageNumber,
    };
  }

  factory PaginationReviewDataModel.fromMap(Map<String, dynamic> map) {
    return PaginationReviewDataModel(
      pageNumber: map['pageNumber'] ?? 1,
      pageSize: map['pageSize'] ?? 10,
      totalComments: map['totalComments'] ?? map['count'] ?? 0,
    );
  }
}
