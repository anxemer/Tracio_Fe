import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/domain/shop/shop_service_entity.dart';
import 'package:tracio_fe/presentation/service/widget/near_location.dart';
import 'package:tracio_fe/presentation/service/widget/service_card.dart';

import '../../../core/constants/app_size.dart';

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        slivers: [
          // Near Location section
          SliverToBoxAdapter(
            child: NearLocation(),
          ),

          // Padding between sections
          SliverToBoxAdapter(
            child: SizedBox(height: 10),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular service',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSize.textMedium.sp,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    'See All',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSize.textMedium.sp,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          // Service grid section
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3,
                mainAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final services = sampleBikeServices[index];

                  return GestureDetector(
                    onTap: () {},
                    child: ServiceCard(
                      service: services,
                    ),
                  );
                },
                childCount: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
