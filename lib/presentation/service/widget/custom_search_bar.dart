import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/bloc/filter_cubit.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/shop/models/get_service_req.dart';
import 'package:Tracio/domain/blog/entites/category.dart';
import 'package:Tracio/presentation/blog/bloc/category/get_category_cubit.dart';
import 'package:Tracio/presentation/service/widget/search_text_field.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key, this.isShopOwner = false});
  final bool isShopOwner;
  // final Function(String)? onSearch;
  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  CategoryEntity? selectedCategory;
  @override
  Widget build(BuildContext context) {
    // Position positionUser;
    var isDark = context.isDarkMode;
    return BlocProvider(
      create: (context) => GetCategoryCubit()..getCategoryService(),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              vertical: AppSize.apVerticalPadding.h * .4,
              horizontal: AppSize.apHorizontalPadding.w),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back,
                      color: isDark ? Colors.white : Colors.black,
                      size: AppSize.iconMedium,
                    ),
                  ),
                  SizedBox(
                    width: 10.h,
                  ),
                  Text(
                    widget.isShopOwner ? 'Services Management' : 'Services',
                    style: TextStyle(
                      fontSize: AppSize.textHeading,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  )
                  // Spacer(),
                  // InkWell(
                  //   onTap: () => AppNavigator.push(context, MyBookingPage()),
                  //   child: Container(
                  //       height: 40.h,
                  //       width: 40.w,
                  //       decoration: BoxDecoration(
                  //         boxShadow: [
                  //           BoxShadow(
                  //               blurRadius: 5,
                  //               color: context.isDarkMode
                  //                   ? Colors.transparent
                  //                   : Colors.grey.shade400,
                  //               offset: Offset(0, 2))
                  //         ],
                  //         color: context.isDarkMode
                  //             ? AppColors.darkGrey
                  //             : Colors.grey.shade200,
                  //         borderRadius:
                  //             BorderRadius.circular(AppSize.borderRadiusLarge),
                  //       ),
                  //       child: Icon(
                  //         Icons.calendar_today,
                  //         color: isDark
                  //             ? AppColors.secondBackground
                  //             : AppColors.background,
                  //         size: AppSize.iconMedium,
                  //       )),
                  // ),
                  // SizedBox(
                  //   width: 10.w,
                  // ),
                  // PlanServiceIcon()
                  // InkWell(
                  //   onTap: () => AppNavigator.push(context, PlanServicePage()),
                  //   child: Container(
                  //       height: 40.h,
                  //       width: 40.w,
                  //       decoration: BoxDecoration(
                  //         boxShadow: [
                  //           BoxShadow(
                  //               blurRadius: 5,
                  //               color: context.isDarkMode
                  //                   ? Colors.transparent
                  //                   : Colors.grey.shade400,
                  //               offset: Offset(0, 2))
                  //         ],
                  //         color: context.isDarkMode
                  //             ? AppColors.darkGrey
                  //             : Colors.grey.shade200,
                  //         borderRadius:
                  //             BorderRadius.circular(AppSize.borderRadiusLarge),
                  //       ),
                  //       child: Icon(
                  //         Icons.edit_calendar_rounded,
                  //         color: isDark
                  //             ? AppColors.secondBackground
                  //             : AppColors.background,
                  //         size: AppSize.iconMedium,
                  //       )),
                  // ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<FilterCubit, GetServiceReq>(
                      builder: (context, state) {
                        return SearchTextField();
                      },
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // InkWell(
                  //   onTap: () => AppNavigator.push(context, FilterView()),
                  //   child: Container(
                  //     height: 32.h,
                  //     width: 32.h,
                  //     decoration: BoxDecoration(
                  //       color:
                  //           isDark ? AppColors.darkGrey : Colors.grey.shade300,
                  //       borderRadius: BorderRadius.circular(20.r),
                  //     ),
                  //     child: Center(
                  //       child: Icon(
                  //         Icons.tune,
                  //         color: isDark
                  //             ? AppColors.secondBackground
                  //             : AppColors.background,
                  //         size: AppSize.iconMedium.sp,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              // FilterView()
            ],
          ),
        ),
      ),
    );
  }
}
