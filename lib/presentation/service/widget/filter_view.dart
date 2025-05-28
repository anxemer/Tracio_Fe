import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/bloc/filter_cubit.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:Tracio/presentation/blog/bloc/category/get_category_state.dart';
import 'package:Tracio/presentation/service/bloc/service_bloc/get_service_cubit.dart';

import '../../../common/input_range_slider.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../data/shop/models/get_service_req.dart';

class FilterView extends StatefulWidget {
  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  Map<FilterType, String?> selectedFilters = {
    FilterType.category: null,
    FilterType.price: null,
  };
  int? selectIndex;
  // String? cateSelected;
  int? _expandedIndex;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          // horizontal: AppSize.apHorizontalPadding,
          vertical: AppSize.apVerticalPadding * 0.4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(FilterType.values.length, (index) {
                return _buildFilterButton(index);
              }),
            ),
          ),

          // Phần mở rộng hiển thị các option
          if (_expandedIndex != null) _buildExpandedSection(_expandedIndex!),
        ],
      ),
    );
  }

  Widget _buildFilterButton(int index) {
    final isExpanded = _expandedIndex == index;
    final filterType =
        FilterType.values[index]; // Xác định loại filter hiện tại

    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            _expandedIndex = isExpanded ? null : index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: AppSize.apHorizontalPadding * .4.h,
              vertical: AppSize.apVerticalPadding * .4.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge),
            border: Border.all(
                color: isExpanded
                    ? AppColors.secondBackground
                    : Colors.grey.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedFilters[filterType] ??
                    filterType
                        .name, // Hiển thị giá trị đã chọn hoặc tên mặc định
                style: TextStyle(
                    fontSize: AppSize.textMedium,
                    fontWeight: FontWeight.w500,
                    color:
                        context.isDarkMode ? Colors.white70 : Colors.black87),
              ),
              SizedBox(width: 4),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: AppSize.iconSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedSection(int index) {
    final filter = FilterType.values[index];

    return Container(
      // margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(
        vertical: AppSize.apVerticalPadding * 0.2,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: _buildFilterContent(filter, index),
    );
  }

  Widget _buildFilterContent(FilterType filter, int index) {
    switch (filter) {
      case FilterType.category:
        return _buildCategoryOptions(index);
      case FilterType.price:
        return _buildPriceRangeOptions(index);
      // case FilterType.location:
      //   return _buildLocationOptions(filter, index);

      default:
        return Container();
    }
  }

  Widget _buildCategoryOptions(int index) {
    var isDark = context.isDarkMode;
    return BlocBuilder<GetCategoryCubit, GetCategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          return
              // CategoryService(cateService: state.categories);
              SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                state.categories.length,
                (i) => Padding(
                  padding: EdgeInsets.all(8),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    child: ChoiceChip(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        label: Text(
                          state.categories[i].categoryName!,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: selectIndex == i
                                  ? AppSize.textLarge
                                  : AppSize.textMedium,
                              color: isDark
                                  ? Colors.grey.shade200
                                  : Colors.black87),
                        ),
                        selectedColor: context.isDarkMode
                            ? AppColors.primary
                            : AppColors.background,
                        selected: selectIndex == i,
                        pressElevation: 0,
                        backgroundColor: Colors.transparent,
                        elevation: selectIndex == i ? 2 : 0,
                        labelPadding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(
                            color: selectIndex == i
                                ? Colors.transparent
                                : isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300),
                        onSelected: (bool selected) {
                          setState(() {
                            selectIndex = selected ? i : null;
                            selectedFilters[FilterType.category] = selected
                                ? state.categories[i].categoryName
                                : null;

                            final filterCubit = context.read<FilterCubit>();
                            filterCubit.update(
                                category:
                                    selected ? state.categories[i] : null);
                          });

                          context
                              .read<GetServiceCubit>()
                              .getService(context.read<FilterCubit>().state);
                        }),
                  ),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildPriceRangeOptions(int index) {
    // Khởi tạo giá trị mặc định nếu chưa có

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding * 0.8),
      child: Column(
        children: [
          Text(
            "Price Range",
            style: TextStyle(
              fontSize: AppSize.textMedium,
              fontWeight: FontWeight.bold,
            ),
          ),
          BlocBuilder<FilterCubit, GetServiceReq>(
            builder: (context, state) {
              return RangeSliderExample(
                initMin: state.priceFrom ?? 0,
                initMax: state.priceTo ?? 1000000,
                onChanged: (double start, double end) {
                  context.read<FilterCubit>().updateRangePrice(start, end);

                  // context.read<GetServiceCubit>().getService(GetServiceReq(
                  //     categoryId: selectIndex! + 1, priceFrom: 0, priceTo: 50));
                },
                max: 1000000,
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              child: Text(
                "Apply",
                style:
                    TextStyle(color: Colors.white, fontSize: AppSize.textLarge),
              ),
              onPressed: () {
                final filterState = context.read<FilterCubit>().state;

                context.read<GetServiceCubit>().getService(filterState);
                //  context
                //                   .read<GetServiceCubit>()
                //                   .getService(GetServiceReq(categoryId: selectIndex,priceFrom: ));
                setState(() {
                  selectedFilters[FilterType.price] =
                      "${filterState.priceFrom?.toInt()}VNĐ - ${filterState.priceTo?.toInt()} VNĐ";
                  _expandedIndex = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum FilterType {
  category,
  price,
}
