import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../page/filter_service.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, this.shopId});
  final int? shopId;

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return TextField(
      readOnly: true,
      onTap: () => AppNavigator.push(
          context,
          FilterServicePage(
            shouldFetchAllServices: false,
            shopId: shopId,
          )),
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        prefixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search_outlined),
        ),
        // suffixIcon: _searchController.text.isNotEmpty
        //     ? IconButton(
        //         onPressed: () {
        //           _searchController.clear();
        //           setState(() {});
        //         },
        //         icon: const Icon(Icons.close),
        //       )
        //     : null,
        hintText: "Search service",
        hintStyle: TextStyle(
            color: context.isDarkMode ? Colors.white : Colors.grey[400]),
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
            borderSide: BorderSide(
                color: isDark ? Colors.white : Colors.grey.shade600)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0.r)),
            borderSide: BorderSide(
                color: isDark
                    ? AppColors.secondBackground
                    : AppColors.background)),
      ),
    );
  }
}
