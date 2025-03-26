import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:tracio_fe/domain/blog/entites/category.dart';

import '../filter_params.dart';

class FilterCubit extends Cubit<FilterParams> {
  final TextEditingController searchController = TextEditingController();
  FilterCubit() : super(const FilterParams());

  void update({
    String? keyword,
    List<CategoryEntity>? categories,
    CategoryEntity? category,
  }) {
    List<CategoryEntity> updatedCategories = [];
    if (category != null) {
      updatedCategories.add(category);
    } else if (categories != null) {
      updatedCategories.addAll(categories);
    } else {
      updatedCategories.addAll(state.categories);
    }
    emit(FilterParams(
      keyword: keyword ?? state.keyword,
      categories: updatedCategories,
    ));
  }

  void updateCategory({
    required CategoryEntity category,
  }) {
    List<CategoryEntity> updatedCategories = [];
    updatedCategories.addAll(state.categories);
    if (updatedCategories.contains(category)) {
      updatedCategories.remove(category);
    } else {
      updatedCategories.add(category);
    }
    emit(state.copyWith(
      categories: updatedCategories,
    ));
  }

  void updateRange(double min, double max) => emit(state.copyWith(
        minPrice: min,
        maxPrice: max,
      ));

  int getFiltersCount() {
    int count = 0;
    count = (state.categories.length) + count;
    count = count + ((state.minPrice != 0 || state.maxPrice != 10000) ? 1 : 0);
    return count;
  }

  void reset() => emit(const FilterParams());
}
