import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
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
                  height: 60.h,
                  width: 60.w,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusMedium)),
                  child: InkWell(
                    onTap: () =>
                        AppNavigator.push(context, BottomNavBarService()),
                    child: Image.asset(
                      AppImages.serviceShop,
                      width: AppSize.imageSmall,
                      height: AppSize.imageSmall,
                    ),
                  ),
                  // IconButton(
                  //     onPressed: () {
                  //       AppNavigator.push(context, ServicePage());
                  //     },
                  //     icon: Icon(
                  //       Icons.shop_2_outlined,
                  //       size: AppSize.iconExtraLarge,
                  //     )),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusMedium)),
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.shop_2_outlined,
                        size: AppSize.iconLarge,
                      )),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusMedium)),
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.shop_2_outlined,
                        size: AppSize.iconLarge,
                      )),
                ),
              ],
            )),
      ),
    );
  }
}
