import 'package:tracio_fe/data/map/models/route_blog_review.dart';
import 'package:tracio_fe/data/map/models/route_reply.dart';
import 'package:tracio_fe/domain/map/entities/route_reply.dart';

class GetRouteReplyRep extends RouteReplyPaginationEntity {
  GetRouteReplyRep(
      {required super.review,
      required super.replies,
      required super.totalCount,
      required super.pageNumber,
      required super.pageSize,
      required super.totalPage,
      required super.hasPreviousPage,
      required super.hasNextPage});

  factory GetRouteReplyRep.fromMap(Map<String, dynamic> map) {
    return GetRouteReplyRep(
      review: RouteBlogReviewModel.fromMap(map["review"]),
      replies: List<RouteReplyEntity>.from(
        (map['replies']).map<RouteReplyEntity>(
          (x) => RouteReplyModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalCount: map['totalReply'] as int,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalPage: map['totalPage'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
    );
  }
}
