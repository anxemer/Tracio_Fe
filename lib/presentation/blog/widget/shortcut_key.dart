import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/challenge/page/challenge.dart';
import 'package:tracio_fe/presentation/service/page/bottom_nav_bar_service.dart';
import 'package:tracio_fe/presentation/service/page/service.dart';

class ShortcutKey extends StatelessWidget {
  const ShortcutKey({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.apHorizontalPadding,
          vertical: AppSize.apVerticalPadding * 0.6),
      child: Center(
        child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: AppSize.apHorizontalPadding * 0.2,
                vertical: AppSize.apVerticalPadding * 0.6),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge)),
            // height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSize.apHorizontalPadding * .6.h,
                      vertical: AppSize.apVerticalPadding * .6.w),
                  // height: 40.h,
                  // width: 40.w,
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusMedium)),
                  child: InkWell(
                    onTap: () =>
                        AppNavigator.push(context, BottomNavBarService()),
                    child: Icon(
                      Icons.store_mall_directory_outlined,
                      size: AppSize.iconLarge,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSize.apHorizontalPadding * .6.h,
                      vertical: AppSize.apVerticalPadding * .6.w),
                  // height: 40.h,
                  // width: 40.w,
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusMedium)),
                  child: InkWell(
                    onTap: () =>
                        AppNavigator.push(context, BottomNavBarService()),
                    child: Icon(
                      Icons.radar_rounded,
                      size: AppSize.iconLarge,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSize.apHorizontalPadding * .6.h,
                      vertical: AppSize.apVerticalPadding * .6.w),
                  // height: 40.h,
                  // width: 40.w,
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusMedium)),
                  child: InkWell(
                    onTap: () =>
                        AppNavigator.push(context, BottomNavBarService()),
                    child: Icon(
                      Icons.store_mall_directory_outlined,
                      size: AppSize.iconLarge,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
