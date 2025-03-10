// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:tracio_fe/domain/blog/entites/pagination_meta_data_entity.dart';

class PaginationMetaData extends PaginationMetaDataEntity {
 
  PaginationMetaData({
    required super.pageNumber,
    required super.pageSize,
    required super.totalBlogs,
    required super.totalPages,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalBlogs': totalBlogs,
      'totalPages': totalPages,
    };
  }

  factory PaginationMetaData.fromMap(Map<String, dynamic> map) {
    return PaginationMetaData(
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalBlogs: map['totalBlogs'] as int,
      totalPages: map['totalPages'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaginationMetaData.fromJson(String source) =>
      PaginationMetaData.fromMap(json.decode(source) as Map<String, dynamic>);
}
