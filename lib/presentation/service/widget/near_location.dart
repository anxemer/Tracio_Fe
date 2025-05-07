import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/presentation/service/page/shop_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/service/bloc/service_bloc/near_service_cubit/get_near_service_cubit.dart';

import '../../../common/widget/picture/picture.dart';
import '../../../core/configs/theme/app_colors.dart';

class NearLocation extends StatelessWidget {
  const NearLocation({super.key});

  @override
  // void initState() {
  //   context.read<GetServiceCubit>().getNearShop();
  //   super.initState();
  // }

  // Future<void> getNearShop() async {
  //   bg.Location location = await bg.BackgroundGeolocation.getCurrentPosition();
  //   context.read<GetServiceCubit>().getService(GetServiceReq(
  //       longitude: location.coords.longitude,
  //       latitude: location.coords.latitude,
  //       distance: 2));
  // }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return BlocBuilder<GetNearServiceCubit, GetNearServiceState>(
      builder: (context, state) {
        if (state is GetNearServiceLoaded) {
          if (state.shop.isEmpty) {
            return Container();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Near you',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSize.textMedium.sp,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    // Text(
                    //   'See All',
                    //   style: TextStyle(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: AppSize.textMedium.sp,
                    //     color: isDark ? Colors.white : Colors.black,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.h,
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
                height: AppSize.imageExtraLarge,
                child: ListView.builder(
                  itemCount: state.shop.length,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 16),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => AppNavigator.push(context,
                          ShopServicePage(shopId: state.shop[index].shopId!)),
                      child: Container(
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
                                  child: PictureCustom(
                                    width: AppSize.imageExtraLarge * 1.4.w,
                                    imageUrl: state.shop[index].profilePicture!,
                                    height: AppSize.imageMedium.h,
                                  )),
                            ),
                            SizedBox(
                              height: AppSize.apVerticalPadding * 0.6.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
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
                                    state.shop[index].shopName!,
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
                                    state.shop[index].formattedDistance,
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
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
