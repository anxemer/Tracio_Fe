import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/widget/button/button.dart';
import 'package:tracio_fe/common/widget/error.dart';
import 'package:tracio_fe/common/widget/picture/circle_picture.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/shop/models/get_service_req.dart';
import 'package:tracio_fe/domain/shop/entities/response/shop_entity.dart';
import 'package:tracio_fe/domain/shop/entities/response/shop_service_entity.dart';
import 'package:tracio_fe/presentation/service/bloc/service_bloc/get_service_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/plan_service_icon.dart';
import 'package:tracio_fe/presentation/service/widget/search_text_field.dart';

import '../../../common/widget/button/text_button.dart';
import '../bloc/service_bloc/get_service_state.dart';
import '../widget/service_card.dart';

class ShopServicePage extends StatefulWidget {
  const ShopServicePage({super.key, required this.shopId});
  final int shopId;

  @override
  State<ShopServicePage> createState() => _ShopServicePageState();
}

class _ShopServicePageState extends State<ShopServicePage> {
  // bool isFilter = false;
  @override
  void initState() {
    // context
    //     .read<GetServiceCubit>()
    //     .getService(GetServiceReq(shopId: widget.shopId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return BlocProvider(
        create: (context) =>
            GetServiceCubit()..getService(GetServiceReq(shopId: widget.shopId)),
        child: BlocBuilder<GetServiceCubit, GetServiceState>(
          builder: (context, state) {
            if (state is GetServiceLoaded) {
              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: buildHeader(isDark, context, state.service[0]),
                    ),
                    buildGrid(state.service),
                  ],
                ),
              );
            } else if (state is GetServiceLoading) {
              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              );
            } else {
              return Scaffold(
                body: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: ErrorPage(),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }

  Padding buildHeader(
      bool isDark, BuildContext context, ShopServiceEntity shop) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.apVerticalPadding),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: AppSize.apVerticalPadding.h,
            horizontal: AppSize.apHorizontalPadding.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            buildSearch(context),
            SizedBox(
              height: 10.h,
            ),
            // isFilter ? FilterView() : Container(),
            SizedBox(
              width: 4.w,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CirclePicture(
                          imageUrl: shop.profilePicture!,
                          imageSize: AppSize.iconLarge),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        children: [
                          Text(
                            shop.shopName!,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey.shade300
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: AppSize.textLarge,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: AppSize.apHorizontalPadding * .8.h),
                            height: 28,
                            // width: 100,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: AppColors.secondBackground),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  color: isDark
                                      ? AppColors.secondBackground
                                      : AppColors.background,
                                  size: AppSize.iconSmall,
                                ),
                                Text(
                                  '${shop.openTime?.substring(0, 5)} - ${shop.closeTime?.substring(0, 5)}',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey.shade300
                                        : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: AppSize.textSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      ButtonDesign(
                        height: 30,
                        width: 40,
                        ontap: () {},
                        fillColor: Colors.transparent,
                        borderColor: AppColors.secondBackground,
                        fontSize: AppSize.textSmall,
                        icon: Icon(Icons.chat_outlined),
                        iconSize: AppSize.iconSmall,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        color: isDark
                            ? AppColors.secondBackground
                            : AppColors.background,
                      ),
                      Text(
                        '${shop.district} ${shop.city}',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.textLarge,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildGrid(List<ShopServiceEntity> service) {
    return service.isEmpty
        ? SliverToBoxAdapter(
            child: Center(child: Text('No services available')),
          )
        : SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3,
                mainAxisSpacing: 16.h,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ServiceCard(
                    service: service[index],
                  );
                },
                childCount: service.length,
              ),
            ),
          );
  }

  Widget buildSearch(BuildContext context) {
    return Row(
      children: [
        InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_rounded)),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: SearchTextField(
          shopId: widget.shopId,
        )),
        SizedBox(
          width: 10,
        ),
        PlanServiceIcon(
          isActive: true,
        ),
        SizedBox(
          width: 4.w,
        ),
        // InkWell(
        //   onTap: () {
        //     setState(() {
        //       isFilter = !isFilter;
        //     });
        //   },
        //   child: Container(
        //     height: 32.h,
        //     width: 32.h,
        //     decoration: BoxDecoration(
        //       color: isDark ? Colors.grey.shade600 : Colors.grey.shade200,
        //       borderRadius: BorderRadius.circular(20.r),
        //     ),
        //     child: Center(
        //       child: Icon(
        //         Icons.tune,
        //         color:
        //             isDark ? AppColors.secondBackground : AppColors.background,
        //         size: AppSize.iconMedium.sp,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
