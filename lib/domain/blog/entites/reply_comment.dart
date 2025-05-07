// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:Tracio/common/widget/blog/comment/comment.dart';
import 'package:Tracio/domain/blog/entites/comment_blog.dart';

import '../../../common/helper/media_file.dart';

class ReplyCommentEntity extends BaseCommentEntity {
  final int replyId;
  final int cyclistId;
  final int? reReplyCyclistId;
  final String cyclistName;
  final String? reReplyCyclistName;
  final List<MediaFile> mediaFiles;
  int likesCount;
  ReplyCommentEntity({
    required this.replyId,
    required this.cyclistId,
    required super.commentId,
    this.reReplyCyclistId,
    required this.cyclistName,
    required this.reReplyCyclistName,
    required super.content,
    required super.isReacted,
    required this.mediaFiles,
    required this.likesCount,
    required super.createdAt,
    required super.tagUserNames,
    required super.mediaUrls,
    required super.likeCount,
    required super.replyCount,
  }) : super(
          userId: cyclistId,
          userName: cyclistName,
          userAvatar: '',
        );
}

class ReplyCommentBlogPaginationEntity {
  final CommentBlogEntity comment;
  final List<ReplyCommentEntity> replies;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPage;
  final bool hasPreviousPage;
  final bool hasNextPage;

  ReplyCommentBlogPaginationEntity({
    required this.comment,
    required this.replies,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  ReplyCommentBlogPaginationEntity copyWith({
    CommentBlogEntity? comment,
    List<ReplyCommentEntity>? replies,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPage,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return ReplyCommentBlogPaginationEntity(
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPage: totalPage ?? this.totalPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      comment: comment ?? this.comment,
      replies: replies ?? this.replies,
    );
  }
}
