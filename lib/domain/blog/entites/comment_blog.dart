import 'package:tracio_fe/common/helper/media_file.dart';
import 'package:tracio_fe/common/widget/blog/comment/comment.dart';
import 'package:tracio_fe/domain/blog/entites/blog_entity.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';

class CommentBlogEntity extends BaseCommentEntity {
  int cyclistId;
  String cyclistName;
  String cyclistAvatar;
  ReplyCommentBlogPaginationEntity? replyCommentPagination;
  List<MediaFile>? mediaFiles;
  CommentBlogEntity({
    required super.commentId,
    required this.cyclistId,
    required this.cyclistName,
    required this.cyclistAvatar,
    required super.content,
    required super.isReacted,
    required super.createdAt,
    required super.likeCount,
    required super.replyCount,
    required super.mediaUrls,
    required super.tagUserNames,
    required this.replyCommentPagination,
    this.mediaFiles,
  }) : super(
          userId: cyclistId,
          userName: cyclistName,
          userAvatar: cyclistAvatar,
        );

  CommentBlogEntity copyWith(
      {int? blogId,
      int? cyclistId,
      String? cyclistName,
      String? cyclistAvatar,
      String? content,
      bool? isReacted,
      DateTime? createdAt,
      int? likeCount,
      int? replyCount,
      List<String>? mediaUrls,
      List<MediaFile>? mediaFiles,
      List<String>? tagUserNames,
      ReplyCommentBlogPaginationEntity? replyCommentPagination}) {
    return CommentBlogEntity(
      commentId: commentId,
      cyclistId: cyclistId ?? this.cyclistId,
      cyclistName: cyclistName ?? this.cyclistName,
      cyclistAvatar: cyclistAvatar ?? this.cyclistAvatar,
      content: content ?? this.content,
      isReacted: isReacted ?? this.isReacted,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      replyCount: replyCount ?? this.replyCount,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      tagUserNames: tagUserNames ?? this.tagUserNames,
      replyCommentPagination:
          replyCommentPagination ?? this.replyCommentPagination,
    );
  }
}

class CommentBlogPaginationEntity {
  final BlogEntity blog;
  final List<CommentBlogEntity> comments;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPage;
  final bool hasPreviousPage;
  final bool hasNextPage;

  CommentBlogPaginationEntity({
    required this.blog,
    required this.comments,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  CommentBlogPaginationEntity copyWith({
    BlogEntity? blog,
    List<CommentBlogEntity>? comments,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPage,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return CommentBlogPaginationEntity(
      comments: comments ?? this.comments,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPage: totalPage ?? this.totalPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      blog: blog ?? this.blog,
    );
  }
}
