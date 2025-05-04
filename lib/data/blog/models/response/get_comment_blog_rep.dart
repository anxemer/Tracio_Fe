import 'package:tracio_fe/data/blog/models/response/blog_model.dart';
import 'package:tracio_fe/data/blog/models/response/comment_blog_model.dart';
import 'package:tracio_fe/domain/blog/entites/comment_blog.dart';

class GetCommentBlogRep extends CommentBlogPaginationEntity {
  GetCommentBlogRep(
      {required super.comments,
      required super.totalCount,
      required super.pageNumber,
      required super.pageSize,
      required super.totalPage,
      required super.hasPreviousPage,
      required super.hasNextPage,
      required super.blog});

  factory GetCommentBlogRep.fromMap(Map<String, dynamic> map) {
    return GetCommentBlogRep(
      comments: (map['comments'] != null)
          ? List<CommentBlogModel>.from(
              (map['comments'] as List).map(
                  (x) => CommentBlogModel.fromMap(x as Map<String, dynamic>)),
            )
          : [],
      totalCount: map['totalComment'] as int,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalPage: map['totalPage'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
      blog: BlogModels.fromJson(map['blog']),
    );
  }
}
