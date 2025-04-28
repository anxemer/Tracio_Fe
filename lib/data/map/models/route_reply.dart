import 'package:tracio_fe/domain/map/entities/route_reply.dart';

class RouteReplyModel extends RouteReplyEntity {
  RouteReplyModel(
      {required super.replyId,
      required super.cyclistId,
      required super.reviewId,
      required super.cyclistName,
      required super.cyclistAvatar,
      required super.tagUserNames,
      required super.content,
      required super.isReacted,
      required super.createdAt,
      required super.likeCount,
      super.reReplyCyclistId,
      super.reReplyCyclistName,
      required super.mediaUrls});

  factory RouteReplyModel.fromMap(Map<String, dynamic> map) {
    return RouteReplyModel(
      replyId: map['replyId'] as int,
      cyclistId: map['cyclistId'] as int,
      reviewId: map['reviewId'] as int,
      cyclistName: map['cyclistName'] as String,
      cyclistAvatar: map['cyclistAvatar'] as String,
      tagUserNames: List<String>.from((map['tagUserNames'])),
      content: map['content'] as String,
      isReacted: map['isReacted'] as bool,
      createdAt: DateTime.parse(map['createdAt']),
      likeCount: map['likesCount'] as int,
      reReplyCyclistId: map['reReplyCyclistId'] != null
          ? map['reReplyCyclistId'] as int
          : null,
      reReplyCyclistName: map['reReplyCyclistName'] != null
          ? map['reReplyCyclistName'] as String
          : null,
      mediaUrls: List<String>.from(map['mediaFiles']),
    );
  }
}
