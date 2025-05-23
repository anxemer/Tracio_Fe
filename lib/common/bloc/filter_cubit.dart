import 'package:Tracio/core/services/location/location_service.dart';
import 'package:Tracio/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:Tracio/data/shop/models/get_service_req.dart';
import 'package:Tracio/domain/blog/entites/category.dart';

class FilterCubit extends Cubit<GetServiceReq> {
  final TextEditingController searchController = TextEditingController();
  FilterCubit() : super(GetServiceReq().copyWith());

  void update({
    String? keyword,
    CategoryEntity? category,
  }) {
    emit(state.copyWith(
      keyword: keyword ?? state.keyword,
      categoryId: category?.categoryId,
    ));
  }

  // void updateCategory({
  //   required CategoryEntity category,
  // }) {
  //   List<CategoryEntity> updatedCategories = [];
  //   updatedCategories.addAll(state.categories);
  //   if (updatedCategories.contains(category)) {
  //     updatedCategories.remove(category);
  //   } else {
  //     updatedCategories.add(category);
  //   }
  //   emit(state.copyWith(
  //     categories: updatedCategories,
  //   ));
  // }

  void updateRangePrice(double start, double end) {
    emit(state.copyWith(priceFrom: start, priceTo: end));
  }

  void updateDistance(double end) async {
    final origin = await sl<LocationService>().getCurrentLocation();

    emit(state.copyWith(
        distance: end,
        latitude: origin!.latitude,
        longitude: origin.longitude));
  }

  // int getFiltersCount() {
  //   int count = 0;
  //   count = (state.categories.length) + count;
  //   count = count + ((state.minPrice != 0 || state.maxPrice != 10000) ? 1 : 0);
  //   return count;
  // }

  void reset() => emit(GetServiceReq().copyWith());
}
