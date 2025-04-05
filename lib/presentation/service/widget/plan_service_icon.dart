import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/presentation/service/bloc/bookingservice/booking_service_cubit.dart';
import 'package:tracio_fe/presentation/service/bloc/cart_item_bloc/cart_item_cubit.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../bloc/cart_item_bloc/cart_item_state.dart';
import '../page/plan_service.dart';

class PlanServiceIcon extends StatelessWidget {
  const PlanServiceIcon({super.key});

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;

    return BlocBuilder<CartItemCubit, CartItemState>(
      builder: (context, state) {
        if (state is GetCartItemLoaded) {
          return badges.Badge(
            position: badges.BadgePosition.topEnd(
              top: 0,
              end: 3,
            ),
            showBadge: true,
            ignorePointer: false,
            badgeContent: Text(
              state.cart.length.toString(),
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black87,
                  fontSize: AppSize.textMedium,
                  fontWeight: FontWeight.w600),
            ),
            badgeAnimation: badges.BadgeAnimation.scale(
              animationDuration: Duration(seconds: 1),
              colorChangeAnimationDuration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              colorChangeAnimationCurve: Curves.easeInCubic,
            ),
            badgeStyle: badges.BadgeStyle(
              shape: badges.BadgeShape.circle,
              badgeColor: AppColors.background,
              padding: EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(AppSize.borderRadiusMedium),
              // borderSide: BorderSide(color: Colors.white, width: 2),

              elevation: 0,
            ),
            child: Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        color: context.isDarkMode
                            ? Colors.transparent
                            : Colors.grey.shade400,
                        offset: Offset(0, 2))
                  ],
                  color: context.isDarkMode
                      ? AppColors.darkGrey
                      : Colors.grey.shade200,
                  borderRadius:
                      BorderRadius.circular(AppSize.borderRadiusLarge),
                ),
                child: IconButton(
                  icon: Icon(Icons.edit_calendar_rounded,
                      color: isDark
                          ? AppColors.secondBackground
                          : AppColors.background,
                      size: AppSize.iconMedium),
                  onPressed: () {
                    AppNavigator.push(context, PlanServicePage());
                  },
                )),
          );
        }
        return Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    color: context.isDarkMode
                        ? Colors.transparent
                        : Colors.grey.shade400,
                    offset: Offset(0, 2))
              ],
              color: context.isDarkMode
                  ? AppColors.darkGrey
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge),
            ),
            child: Icon(
              Icons.edit_calendar_rounded,
              color: isDark ? AppColors.secondBackground : AppColors.background,
              size: AppSize.iconMedium,
            ));
      },
    );
  }
}
