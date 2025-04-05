import 'dart:convert';

import '../../../../domain/blog/entites/category.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    super.categoryId,
    super.categoryName,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
return CategoryModel(
      categoryId: map['categoryId'] as int?,
      categoryName: map['categoryName'] as String?,
    );
  }

  factory CategoryModel.fromJson(String source) {
    final Map<String, dynamic> data = json.decode(source);
    return CategoryModel.fromMap(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }

  String toJson() => json.encode(toMap());
}
