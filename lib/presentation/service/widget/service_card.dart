import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/shop/entities/response/shop_service_entity.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../page/detail_service.dart';

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service});
  final ShopServiceEntity service;
  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return InkWell(
      onTap: () =>
          AppNavigator.push(context, DetailServicePage(service: service)),
      child: Container(
        // constraints: BoxConstraints(maxWidth: screenWidth),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.3)
                      : Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 2))
            ]),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: Image.asset(
                  AppImages.picture,
                  // width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width > 360 ? 12 : 8),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          service.serviceName ?? 'No Service Name',
                          style: TextStyle(
                              fontSize: AppSize.textMedium.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: AppSize.iconSmall,
                          color: isDark
                              ? AppColors.secondBackground
                              : AppColors.background,
                        ),
                        Text(
                          service.formattedDuration,
                          style: TextStyle(fontSize: AppSize.textSmall),
                        ),
                        const Spacer(),
                        // SizedBox(
                        //   width: 20.w,
                        // ),
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money_rounded,
                              size: AppSize.iconMedium,
                              color: isDark
                                  ? AppColors.secondBackground
                                  : AppColors.background,
                            ),
                            Text(
                              service.price.toString(),
                              style: TextStyle(fontSize: AppSize.textLarge),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.storefront_outlined,
                          size: AppSize.iconSmall,
                          color: isDark
                              ? AppColors.secondBackground
                              : AppColors.background,
                        ),
                        Text(
                          service.shopName ?? 'No Shop Name',
                          style: TextStyle(
                              fontSize: AppSize.textSmall,
                              color: isDark ? Colors.white : Colors.black),
                        ),
                        // const Spacer(),
                        // SizedBox(
                        //   width: 20.w,
                        // ),
                        // Icon(
                        //   Icons.location_on_outlined,
                        //   size: AppSize.iconSmall,
                        //   color: isDark
                        //       ? AppColors.secondBackground
                        //       : AppColors.background,
                        // ),
                        // Text(
                        //   '2 KM',
                        //   style: TextStyle(
                        //       fontSize: AppSize.textSmall,
                        //       color: isDark ? Colors.white : Colors.black),
                        // ),
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
