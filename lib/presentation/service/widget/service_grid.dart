import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/domain/shop/entities/response/shop_service_entity.dart';
import 'package:Tracio/presentation/service/page/filter_service.dart';
import 'package:Tracio/presentation/service/widget/near_location.dart';
import 'package:Tracio/presentation/service/widget/service_card.dart';

import '../../../core/constants/app_size.dart';

class ServiceGrid extends StatelessWidget {
  const ServiceGrid(
      {super.key, required this.services, this.isShopOwner = false});
  final List<ShopServiceEntity> services;
  final bool isShopOwner;
  // final List<ShopEntity> shop;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          // Near Location section

          SliverToBoxAdapter(
            child: isShopOwner ? SizedBox.shrink() : NearLocation(),
          ),

          // Padding between sections
          SliverToBoxAdapter(
            child: isShopOwner ? SizedBox.shrink() : SizedBox(height: 10.h),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSize.apHorizontalPadding.w),
              child: !isShopOwner
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Service',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSize.textMedium.sp,
                            color: context.isDarkMode
                                ? Colors.grey.shade300
                                : Colors.black87,
                          ),
                        ),
                        InkWell(
                          onTap: () => AppNavigator.push(
                              context,
                              FilterServicePage(
                                shouldAutoFocus: false,
                                shouldFetchAllServices: true,
                              )),
                          child: Text(
                            'See All',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSize.textMedium.sp,
                              color: context.isDarkMode
                                  ? Colors.grey.shade300
                                  : Colors.black87,
                            ),
                          ),
                        )
                      ],
                    )
                  : SizedBox.shrink(),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 8.h),
          ),
          // Service grid section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3,
                mainAxisSpacing: 16.h,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return isShopOwner
                      ? ServiceCard(
                          isShopOwner: isShopOwner,
                          service: services[index],
                        )
                      : ServiceCard(
                          service: services[index],
                        );
                },
                childCount: isShopOwner ? services.length : 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
