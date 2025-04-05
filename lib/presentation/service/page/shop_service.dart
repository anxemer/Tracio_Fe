import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/widget/button/button.dart';
import 'package:tracio_fe/common/widget/picture/circle_picture.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/shop/models/get_service_req.dart';
import 'package:tracio_fe/presentation/service/bloc/service_bloc/get_service_cubit.dart';
import 'package:tracio_fe/presentation/service/widget/filter_view.dart';
import 'package:tracio_fe/presentation/service/widget/plan_service_icon.dart';
import 'package:tracio_fe/presentation/service/widget/search_text_field.dart';

import '../bloc/service_bloc/get_service_state.dart';
import '../widget/service_card.dart';

class ShopServicepage extends StatefulWidget {
  const ShopServicepage({super.key, required this.shopId});
  final int shopId;

  @override
  State<ShopServicepage> createState() => _ShopServicepageState();
}

class _ShopServicepageState extends State<ShopServicepage> {
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
      child: Scaffold(
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: buildHeader(isDark, context)),
          // SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: 10.h,
          //   ),
          // ),
          buildGrid()
        ]),
      ),
    );
  }

  Padding buildHeader(bool isDark, BuildContext context) {
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
            Row(
              children: [
                CirclePicture(
                    imageUrl:
                        'https://bizweb.dktcdn.net/100/481/209/products/img-5958-jpeg.jpg?v=1717069788060',
                    imageSize: AppSize.iconMedium),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: Text(
                  'Shop name',
                  style: TextStyle(
                      fontSize: AppSize.textLarge,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87),
                )),
                ButtonDesign(
                  width: 92.w,
                  height: 30.h,
                  ontap: () {},
                  fillColor: Colors.transparent,
                  borderColor: isDark
                      ? AppColors.secondBackground
                      : AppColors.background,
                  fontSize: AppSize.textMedium,
                  text: 'Chat',
                  icon: Icon(
                    Icons.chat_outlined,
                    size: AppSize.iconSmall,
                  ),
                )
                // BasicTextButton(
                //   text: 'Chat',
                //   onPress: () {},
                //   borderColor:
                //       isDark ? AppColors.secondBackground : AppColors.background,
                //   fontSize: AppSize.textLarge,
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid() {
    return BlocBuilder<GetServiceCubit, GetServiceState>(
      builder: (context, state) {
        if (state is GetServiceLoaded) {
          if (state.service.isEmpty) {
            return SliverToBoxAdapter(
              child: Center(child: Text('No services available')),
            );
          }

          return SliverPadding(
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
                    service: state.service[index],
                  );
                },
                childCount: state.service.length,
              ),
            ),
          );
        } else if (state is GetServiceLoading) {
          return SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        }
        return SliverToBoxAdapter(child: Text('k có dì'));
      },
    );
  }

  Widget buildSearch(BuildContext context) {
    var isDark = context.isDarkMode;
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
        PlanServiceIcon(),
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
