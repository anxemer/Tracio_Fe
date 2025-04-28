import 'package:tracio_fe/common/widget/blog/comment/comment.dart';
import 'package:tracio_fe/domain/map/entities/route_reply.dart';

class RouteReviewEntity extends BaseCommentEntity {
  int reviewId;
  int cyclistId;
  String cyclistName;
  String cyclistAvatar;
  RouteReplyPaginationEntity? replyPagination;
  RouteReviewEntity(
      {required this.reviewId,
      required this.cyclistId,
      required this.cyclistName,
      required this.cyclistAvatar,
      required super.tagUserNames,
      required super.content,
      required super.isReacted,
      required super.createdAt,
      required super.likeCount,
      required super.replyCount,
      required super.mediaUrls,
      required this.replyPagination})
      : super(
          commentId: reviewId,
          userId: cyclistId,
          userName: cyclistName,
          userAvatar: cyclistAvatar,
        );

  String formatDateTime(DateTime dateTime) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    String month = months[dateTime.month - 1];
    String day = dateTime.day.toString();
    String year = dateTime.year.toString();

    int hour = dateTime.hour;
    String minute = dateTime.minute < 10
        ? '0${dateTime.minute}'
        : dateTime.minute.toString();

    String amPm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;

    return '$month $day, $year at $hour:$minute $amPm';
  }

  RouteReviewEntity copyWith(
      {int? reviewId,
      int? cyclistId,
      String? cyclistName,
      String? cyclistAvatar,
      List<String>? tagUserNames,
      String? content,
      bool? isReacted,
      DateTime? createdAt,
      int? likeCount,
      int? replyCount,
      List<String>? mediaUrls,
      RouteReplyPaginationEntity? replyPagination}) {
    return RouteReviewEntity(
        reviewId: reviewId ?? this.reviewId,
        cyclistId: cyclistId ?? this.cyclistId,
        cyclistName: cyclistName ?? this.cyclistName,
        cyclistAvatar: cyclistAvatar ?? this.cyclistAvatar,
        tagUserNames: tagUserNames ?? this.tagUserNames,
        content: content ?? this.content,
        isReacted: isReacted ?? this.isReacted,
        createdAt: createdAt ?? this.createdAt,
        mediaUrls: mediaUrls ?? this.mediaUrls,
        likeCount: likeCount ?? this.likeCount,
        replyCount: replyCount ?? this.replyCount,
        replyPagination: replyPagination ?? this.replyPagination);
  }
}

class RouteReviewPaginationEntity {
  final List<RouteReviewEntity> reviews;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPage;
  final bool hasPreviousPage;
  final bool hasNextPage;
  RouteReviewPaginationEntity({
    required this.reviews,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  RouteReviewPaginationEntity copyWith({
    List<RouteReviewEntity>? reviews,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPage,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return RouteReviewPaginationEntity(
      reviews: reviews ?? this.reviews,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPage: totalPage ?? this.totalPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
