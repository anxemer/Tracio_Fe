import 'package:Tracio/domain/blog/entites/pagination_meta_data_entity.dart';

class PaginationMetaData extends PaginationMetaDataEntity {
  PaginationMetaData({
    required super.isSeen,
    required super.pageNumber,
    required super.pageSize,
    required super.totalSeenBlogs,
    required super.totalSeenBlogPages,
    required super.hasNextPage,
    required super.hasPreviousPage,
  });

  factory PaginationMetaData.fromJson(Map<String, dynamic> json) {
    return PaginationMetaData(
      isSeen: json["isSeen"],
      pageNumber: json["pageNumber"],
      pageSize: json["pageSize"],
      totalSeenBlogs: json["totalSeenBlogs"],
      totalSeenBlogPages: json["totalSeenBlogPages"],
      hasPreviousPage: json['hasPreviousPage'] != null
          ? json['hasPreviousPage'] as bool
          : null,
      hasNextPage:
          json['hasNextPage'] != null ? json['hasNextPage'] as bool : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "isSeen": isSeen,
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "totalSeenBlogs": totalSeenBlogs,
        "totalSeenBlogPages": totalSeenBlogPages,
        "hasNextPage": hasNextPage,
        "hasPreviousPage": hasPreviousPage,
      };
}
