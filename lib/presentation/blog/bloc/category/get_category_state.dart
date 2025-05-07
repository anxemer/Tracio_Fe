// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Tracio/domain/blog/entites/category.dart';

abstract class GetCategoryState {}

class CategoryLoading extends GetCategoryState {}

class CategoryLoaded extends GetCategoryState {
  List<CategoryEntity> categories;
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
