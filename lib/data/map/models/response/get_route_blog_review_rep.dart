import 'package:tracio_fe/data/map/models/route_blog_review.dart';
import 'package:tracio_fe/domain/map/entities/route_review.dart';

class GetRouteBlogReviewRep extends RouteReviewPaginationEntity {
  GetRouteBlogReviewRep({
    required super.reviews,
    required super.totalCount,
    required super.pageNumber,
    required super.pageSize,
    required super.totalPage,
    required super.hasPreviousPage,
    required super.hasNextPage,
  });
  factory GetRouteBlogReviewRep.fromMap(Map<String, dynamic> map) {
    return GetRouteBlogReviewRep(
      reviews: List<RouteBlogReviewModel>.from(
        (map['reviews']).map<RouteBlogReviewModel>(
          (x) => RouteBlogReviewModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalCount: map['totalReview'] as int,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalPage: map['totalPage'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
    );
  }
}
