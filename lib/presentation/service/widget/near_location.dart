import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/constants/app_size.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';

class NearLocation extends StatelessWidget {
  const NearLocation({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Section',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.textMedium.sp,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              Text(
                'See All',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.textMedium.sp,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
          height: AppSize.imageExtraLarge,
          child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(right: 16),
            itemBuilder: (context, index) {
              return Container(
                width: AppSize.cardWidth,
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                          color: isDark
                              ? Colors.black.withValues(alpha: .3)
                              : Colors.grey.withValues(alpha: .3),
                          blurRadius: 5,
                          offset: Offset(0, 2))
                    ]),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
                        child: Image.asset(
                          AppImages.picture,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: AppSize.apVerticalPadding * 0.6.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            size: AppSize.iconMedium,
                            color: isDark
                                ? AppColors.secondBackground
                                : AppColors.background,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'An Xểm',
                            style: TextStyle(
                                fontSize: AppSize.textMedium,
                                color: isDark
                                    ? Colors.grey.shade200
                                    : Colors.black87),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Icon(
                            Icons.location_on_outlined,
                            size: AppSize.iconMedium,
                            color: isDark
                                ? AppColors.secondBackground
                                : AppColors.background,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '2 KM',
                            style: TextStyle(
                                fontSize: AppSize.textMedium,
                                color: isDark
                                    ? Colors.grey.shade200
                                    : Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
