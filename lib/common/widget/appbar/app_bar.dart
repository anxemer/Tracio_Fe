import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final Color? backgroundColor;
  final bool hideBack;
  final double? height;
  final bool? centralTitle;
  final int? data;
  final EdgeInsetsGeometry? padding;

  const BasicAppbar({
    this.title,
    this.hideBack = false,
    this.action,
    this.backgroundColor,
    this.height,
    this.centralTitle,
    this.data,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: backgroundColor ?? AppColors.darkGrey,
        elevation: 0,
        centerTitle: centralTitle ?? false,
        automaticallyImplyLeading:
            false, // Don't automatically show back button
        toolbarHeight: AppSize.appBarHeight.h,
        title: Padding(
          padding: padding ??
              EdgeInsets.symmetric(
                  horizontal: !hideBack ? 0 : AppSize.apHorizontalPadding.w),
          child: title ??
              const Text(
                '',
                style: TextStyle(color: Colors.white),
              ),
        ),
        titleSpacing: hideBack ? 0 : 24.w,
        actions: [
          action ?? Container(),
        ],
        leading: hideBack
            ? null
            : Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        padding != null ? AppSize.apHorizontalPadding.w : 0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context, data);
                  },
                  icon: Container(
                    height: AppSize.imageMedium.h,
                    width: AppSize.imageMedium.w,
                    decoration: const BoxDecoration(
                        color: Colors.transparent, shape: BoxShape.circle),
                    child: Icon(Icons.arrow_back_ios_new,
                        size: AppSize.iconSmall, color: Colors.white),
                  ),
                ),
              ));
  }

  @override
  Size get preferredSize => Size.fromHeight(AppSize.appBarHeight.h);
}
