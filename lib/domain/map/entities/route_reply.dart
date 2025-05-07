// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:Tracio/common/widget/blog/comment/comment.dart';
import 'package:Tracio/domain/map/entities/route_review.dart';

class RouteReplyEntity extends BaseCommentEntity {
  int replyId;
  int cyclistId;
  int reviewId;
  String cyclistName;
  String cyclistAvatar;
  int? reReplyCyclistId;
  String? reReplyCyclistName;
  RouteReplyEntity({
    required this.replyId,
    required this.cyclistId,
    required this.reviewId,
    required this.cyclistName,
    required this.cyclistAvatar,
    required super.tagUserNames,
    required super.content,
    required super.isReacted,
    required super.mediaUrls,
    required super.createdAt,
    required super.likeCount,
    this.reReplyCyclistId,
    this.reReplyCyclistName,
  }) : super(
            commentId: replyId,
            userId: cyclistId,
            userName: cyclistName,
            userAvatar: cyclistAvatar,
            replyCount: 0);

  RouteReplyEntity copyWith({
    int? replyId,
    int? cyclistId,
    int? reviewId,
    String? cyclistName,
    String? cyclistAvatar,
    List<String>? tagUserNames,
    String? content,
    bool? isReacted,
    DateTime? createdAt,
    int? likeCount,
    List<String>? mediaUrls,
    int? reReplyCyclistId,
    String? reReplyCyclistName,
  }) {
    return RouteReplyEntity(
      replyId: replyId ?? this.replyId,
      cyclistId: cyclistId ?? this.cyclistId,
      reviewId: reviewId ?? this.reviewId,
      cyclistName: cyclistName ?? this.cyclistName,
      cyclistAvatar: cyclistAvatar ?? this.cyclistAvatar,
      tagUserNames: tagUserNames ?? this.tagUserNames,
      content: content ?? this.content,
      isReacted: isReacted ?? this.isReacted,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      reReplyCyclistId: reReplyCyclistId ?? this.reReplyCyclistId,
      reReplyCyclistName: reReplyCyclistName ?? this.reReplyCyclistName,
    );
  }
}

class RouteReplyPaginationEntity {
  final RouteReviewEntity review;
  List<RouteReplyEntity> replies;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPage;
  final bool hasPreviousPage;
  final bool hasNextPage;
  RouteReplyPaginationEntity({
    required this.review,
    required this.replies,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  RouteReplyPaginationEntity copyWith({
    RouteReviewEntity? review,
    List<RouteReplyEntity>? replies,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPage,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return RouteReplyPaginationEntity(
      review: review ?? this.review,
      replies: replies ?? this.replies,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPage: totalPage ?? this.totalPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  @override
  bool operator ==(covariant RouteReplyPaginationEntity other) {
    if (identical(this, other)) return true;

    return other.review == review &&
        listEquals(other.replies, replies) &&
        other.totalCount == totalCount &&
        other.pageNumber == pageNumber &&
        other.pageSize == pageSize &&
        other.totalPage == totalPage &&
        other.hasPreviousPage == hasPreviousPage &&
        other.hasNextPage == hasNextPage;
  }

  @override
  int get hashCode {
    return review.hashCode ^
        replies.hashCode ^
        totalCount.hashCode ^
        pageNumber.hashCode ^
        pageSize.hashCode ^
        totalPage.hashCode ^
        hasPreviousPage.hashCode ^
        hasNextPage.hashCode;
  }
}
