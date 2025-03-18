import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

class CustomeSearchBar extends StatefulWidget {
  const CustomeSearchBar({super.key});

  @override
  State<CustomeSearchBar> createState() => _CustomeSearchBarState();
}

class _CustomeSearchBarState extends State<CustomeSearchBar> {
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
    var isDark = context.isDarkMode;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Phần location
          Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: AppSize.textMedium.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Location với icon
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: isDark
                              ? AppColors.secondBackground
                              : AppColors.background,
                          size: AppSize.iconMedium.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'New York, USA',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: AppSize.textMedium.sp,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: isDark
                              ? AppColors.secondBackground
                              : AppColors.background,
                          size: AppSize.iconMedium.sp,
                        ),
                      ],
                    ),
                    // Bell icon
                    Container(
                      decoration: BoxDecoration(
                        color:
                            isDark ? AppColors.darkGrey : Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(6.r),
                      child: Icon(
                        Icons.notifications_none_outlined,
                        color: isDark
                            ? AppColors.secondBackground
                            : AppColors.background,
                        size: AppSize.iconMedium.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
                        borderSide: BorderSide(
                            color:
                                isDark ? Colors.white : Colors.grey.shade600)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
                        borderSide: BorderSide(
                            color: isDark
                                ? AppColors.secondBackground
                                : AppColors.background)),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
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
            ],
          ),
        ],
      ),
    );
  }
}
