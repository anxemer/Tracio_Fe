// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tracio_fe/domain/blog/entites/category_blog.dart';

abstract class GetCategoryState {}

class CategoryLoading extends GetCategoryState {}

class CategoryLoaded extends GetCategoryState {
  List<CategoryBlogEntity> categories;
  CategoryLoaded({
    required this.categories,
  });
}

class CategoryFailure extends GetCategoryState {
  String message;
  CategoryFailure({
    required this.message,
  });
}
