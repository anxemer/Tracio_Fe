import 'dart:convert';

import '../../../domain/blog/entites/category_blog.dart';

class CategoryBlogModel {
  final int? categoryId;
  final String? categoryName;

  CategoryBlogModel({
    this.categoryId,
    this.categoryName,
  });

  factory CategoryBlogModel.fromMap(Map<String, dynamic> map) {
    return CategoryBlogModel(
      categoryId: map['categoryId'] as int?,
      categoryName: map['categoryName'] as String?,
    );
  }

  factory CategoryBlogModel.fromJson(String source) {
    final Map<String, dynamic> data = json.decode(source);
    return CategoryBlogModel.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }

  String toJson() => json.encode(toMap());
}

extension cateXModel on CategoryBlogModel {
  CategoryBlogEntity toEntity() {
    return CategoryBlogEntity(
        categoryId: categoryId, categoryName: categoryName);
  }
}
