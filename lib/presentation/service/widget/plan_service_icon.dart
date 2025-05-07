import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/presentation/service/bloc/cart_item_bloc/cart_item_cubit.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../bloc/cart_item_bloc/cart_item_state.dart';
import '../page/plan_service.dart';

class PlanServiceIcon extends StatelessWidget {
  const PlanServiceIcon(
      {super.key, required this.isActive, this.isDetail = false});
  final bool isActive;

  final bool isDetail;
  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;

    return BlocBuilder<CartItemCubit, CartItemState>(
      builder: (context, state) {
        if (state is GetCartItemLoaded) {
          return badges.Badge(
            position: badges.BadgePosition.topEnd(
              top: -8,
              end: -10,
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
              // padding: EdgeInsets.all(5),
              borderRadius: BorderRadius.circular(AppSize.borderRadiusMedium),
              // borderSide: BorderSide(color: Colors.white, width: 2),

              elevation: 0,
            ),
            child: InkWell(
              onTap: () {
                isDetail
                    ? AppNavigator.push(context, PlanServicePage())
                    : SizedBox.shrink();
              },
              child: Icon(Icons.edit_calendar_rounded,
                  color: isActive ? AppColors.primary : Colors.grey.shade600,
                  size: AppSize.iconSmall),
            ),
            //  IconButton(
            //   padding: EdgeInsets.zero,
            //   constraints: BoxConstraints(),
            //   icon:
            //   onPressed: () {
            //     AppNavigator.push(context, PlanServicePage());
            //   },
            // ),
          );
        }
        return Icon(
          Icons.edit_calendar_rounded,
          color: AppColors.primary,
          size: AppSize.iconSmall,
        );
      },
    );
  }
}
