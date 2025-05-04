import 'package:tracio_fe/domain/blog/entites/pagination_meta_data_entity.dart';

class PaginationMetaData extends PaginationMetaDataEntity {
  PaginationMetaData({
    required super.isSeen,
    required super.pageNumber,
    required super.pageSize,
    required super.totalSeenBlogs,
    required super.totalSeenBlogPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  final bool? hasNextPage;
  final bool? hasPreviousPage;

  PaginationMetaData copyWith({
    bool? isSeen,
    int? pageNumber,
    int? pageSize,
    int? totalSeenBlogs,
    int? totalSeenBlogPages,
    bool? hasNextPage,
    bool? hasPreviousPage,
  }) {
    return PaginationMetaData(
      isSeen: isSeen ?? this.isSeen,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalSeenBlogs: totalSeenBlogs ?? this.totalSeenBlogs,
      totalSeenBlogPages: totalSeenBlogPages ?? this.totalSeenBlogPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
    );
  }

  factory PaginationMetaData.fromJson(Map<String, dynamic> json) {
    return PaginationMetaData(
      isSeen: json["isSeen"],
      pageNumber: json["pageNumber"],
      pageSize: json["pageSize"],
      totalSeenBlogs: json["totalSeenBlogs"],
      totalSeenBlogPages: json["totalSeenBlogPages"],
      hasNextPage: json["hasNextPage"],
      hasPreviousPage: json["hasPreviousPage"],
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
