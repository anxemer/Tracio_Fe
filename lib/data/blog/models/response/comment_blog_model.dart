import 'package:Tracio/domain/blog/entites/comment_blog.dart';

import '../../../../common/helper/media_file.dart';

class CommentBlogModel extends CommentBlogEntity {
  CommentBlogModel(
      {required super.commentId,
      required super.cyclistId,
      required super.cyclistName,
      required super.cyclistAvatar,
      required super.likeCount,
      required super.replyCount,
      required super.mediaUrls,
      required super.mediaFiles,
      required super.tagUserNames,
      required super.content,
      required super.isReacted,
      required super.createdAt,
      super.replyCommentPagination});

  factory CommentBlogModel.fromMap(Map<String, dynamic> map) {
    return CommentBlogModel(
        commentId: map['commentId'] as int,
        cyclistId: map['cyclistId'] as int,
        cyclistName: map['cyclistName'] as String,
        cyclistAvatar: map['cyclistAvatar'] as String,
        tagUserNames: [],
        content: map['content'] as String,
        isReacted: map['isReacted'] as bool,
        createdAt: DateTime.parse(map["createdAt"]),
        likeCount: map['likeCount'] as int,
        replyCount: map['replyCount'] as int,
        mediaUrls: map['mediaUrls'] ?? [],
        mediaFiles: map["mediaFiles"] == null
            ? []
            : List<MediaFile>.from(
                map["mediaFiles"]!.map((x) => MediaFile.fromJson(x))));
  }
}
