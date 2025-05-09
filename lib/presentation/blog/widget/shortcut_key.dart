import 'package:Tracio/presentation/groups/pages/group.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/pages/route_planner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/service/page/bottom_nav_bar_service.dart';

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
                color: Colors.transparent,
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
                    onTap: () => AppNavigator.push(context, GroupPage()),
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
                    onTap: () => AppNavigator.push(context, RoutePlanner()),
                    child: Icon(
                      Icons.route,
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
