import 'package:tracio_fe/domain/map/entities/route_review.dart';

class RouteBlogReviewModel extends RouteReviewEntity {
  RouteBlogReviewModel(
      {required super.reviewId,
      required super.cyclistId,
      required super.cyclistName,
      required super.cyclistAvatar,
      required super.tagUserNames,
      required super.content,
      required super.isReacted,
      required super.createdAt,
      required super.likeCount,
      required super.replyCount,
      required super.mediaUrls,
      super.replyPagination});

  factory RouteBlogReviewModel.fromMap(Map<String, dynamic> map) {
    return RouteBlogReviewModel(
      reviewId: map['reviewId'] as int,
      cyclistId: map['cyclistId'] as int,
      cyclistName: map['cyclistName'] as String,
      cyclistAvatar: map['cyclistAvatar'] as String,
      tagUserNames: List<String>.from((map['tagUserNames'])),
      content: map['content'] as String,
      isReacted: map['isReacted'] as bool,
      createdAt: DateTime.parse(map["createdAt"]),
      likeCount: map['likeCount'] as int,
      replyCount: map['replyCount'] as int,
      mediaUrls: map['mediaUrls'] ?? [],
    );
  }
}
