import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/service/page/my_booking.dart';
import 'package:tracio_fe/presentation/service/page/plan_service.dart';
import 'package:tracio_fe/presentation/service/widget/filter_view.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  String _previousSearchText = "";
  void _onSearchChanged() {
    final currentText = _searchController.text.trim();

    if (currentText == _previousSearchText) return;

    setState(() {});
    _previousSearchText = currentText;
  }

  @override
  Widget build(BuildContext context) {
    // Position positionUser;
    var isDark = context.isDarkMode;
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: AppSize.apVerticalPadding.h,
            horizontal: AppSize.apHorizontalPadding.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 5,
                            color: context.isDarkMode
                                ? Colors.transparent
                                : Colors.grey.shade400,
                            offset: Offset(0, 2))
                      ],
                      color: context.isDarkMode
                          ? AppColors.darkGrey
                          : Colors.grey.shade200,
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusLarge),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: isDark
                          ? AppColors.secondBackground
                          : AppColors.background,
                      size: AppSize.iconMedium,
                    )),
                Spacer(),
                InkWell(
                  onTap: () => AppNavigator.push(context, MyBookingPage()),
                  child: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: context.isDarkMode
                                  ? Colors.transparent
                                  : Colors.grey.shade400,
                              offset: Offset(0, 2))
                        ],
                        color: context.isDarkMode
                            ? AppColors.darkGrey
                            : Colors.grey.shade200,
                        borderRadius:
                            BorderRadius.circular(AppSize.borderRadiusLarge),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: isDark
                            ? AppColors.secondBackground
                            : AppColors.background,
                        size: AppSize.iconMedium,
                      )),
                ),
                SizedBox(
                  width: 10.w,
                ),
                InkWell(
                  onTap: () => AppNavigator.push(context, PlanServicePage()),
                  child: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: context.isDarkMode
                                  ? Colors.transparent
                                  : Colors.grey.shade400,
                              offset: Offset(0, 2))
                        ],
                        color: context.isDarkMode
                            ? AppColors.darkGrey
                            : Colors.grey.shade200,
                        borderRadius:
                            BorderRadius.circular(AppSize.borderRadiusLarge),
                      ),
                      child: Icon(
                        Icons.edit_calendar_rounded,
                        color: isDark
                            ? AppColors.secondBackground
                            : AppColors.background,
                        size: AppSize.iconMedium,
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.transparent,
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.search_outlined),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.close),
                            )
                          : null,
                      hintText: "Search service",
                      hintStyle: TextStyle(
                          color: context.isDarkMode
                              ? Colors.white
                              : Colors.grey[400]),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 10.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0.r)),
                          borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white
                                  : Colors.grey.shade600)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0.r)),
                          borderSide: BorderSide(
                              color: isDark
                                  ? AppColors.secondBackground
                                  : AppColors.background)),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                InkWell(
                  onTap: () => AppNavigator.push(context, FilterView()),
                  child: Container(
                    height: 32.h,
                    width: 32.h,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkGrey : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.tune,
                        color: isDark
                            ? AppColors.secondBackground
                            : AppColors.background,
                        size: AppSize.iconMedium.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
