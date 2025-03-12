import 'dart:convert';

import '../../../../domain/blog/entites/category_blog.dart';

List<CategoryBlogModel> categoryModelListFromRemoteJson(String str) =>
    List<CategoryBlogModel>.from(json
        .decode(str)['result']['categories']
        .map((x) => CategoryBlogModel.fromJson(x)));

class CategoryBlogModel extends CategoryBlogEntity {
  CategoryBlogModel({
    super.categoryId,
    super.categoryName,
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
