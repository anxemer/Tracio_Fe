// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:Tracio/data/blog/models/response/blog_model.dart';
import 'package:Tracio/common/helper/pagination_meta_data.dart';
import 'package:Tracio/domain/blog/entites/blog_response.dart';

import '../../../../domain/blog/entites/blog_entity.dart';
import '../../../../domain/blog/entites/pagination_meta_data_entity.dart';

class BlogResponse extends BlogResponseEntity {
  BlogResponse({
    required List<BlogEntity> blogs,
    required PaginationMetaDataEntity meta,
  }) : super(blogs: blogs, paginationMetaDataEntity: meta);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'blogs': List<dynamic>.from(
          (blogs as List<BlogModels>).map((x) => x.toJson())),
      'meta': (paginationMetaDataEntity as PaginationMetaData).toJson(),
    };
  }

  factory BlogResponse.fromMap(Map<String, dynamic> map) {
    final resultMap = map['result'];
    if (resultMap == null) {
      throw FormatException("Missing 'result' field in API response");
    }
    final metaData = PaginationMetaData(
      totalSeenBlogs: resultMap['totalSeenBlog'],
      pageNumber: resultMap['pageNumber'] ?? 1,
      pageSize: resultMap['pageSize'] ?? 5,
      isSeen: resultMap['isSeen'],
      totalSeenBlogPages: resultMap['totalSeenBlogPage'],
      hasNextPage: resultMap['hasNextPage'],
      hasPreviousPage: resultMap['hasPreviousPage'],
    );
    final List<dynamic> blogsList = resultMap['blogs'] ?? [];
    return BlogResponse(
      blogs: List<BlogModels>.from(
          blogsList.map((x) => BlogModels.fromJson(x as Map<String, dynamic>))),
      meta: metaData,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlogResponse.fromJson(String source) =>
      BlogResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
