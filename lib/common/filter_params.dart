// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Tracio/domain/blog/entites/category.dart';

class FilterParams {
  final String? keyword;
  final List<CategoryEntity> categories;
  final double minPrice;
  final double maxPrice;
  final int? limit;
  final int? pageSize;

  const FilterParams({
    this.keyword = '',
    this.categories = const [],
    this.minPrice = 0,
    this.maxPrice = 1000,
    this.limit = 0,
    this.pageSize = 10,
  });

  FilterParams copyWith({
    String? keyword,
    List<CategoryEntity>? categories,
    double? minPrice,
    double? maxPrice,
    int? limit,
    int? pageSize,
  }) {
    return FilterParams(
      keyword: keyword ?? this.keyword,
      categories: categories ?? this.categories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      limit: limit ?? this.limit,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
