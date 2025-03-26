import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/app_size.dart';

class InputFormButton extends StatelessWidget {
  final Function() onClick;
  final String? titleText;
  final Icon? icon;
  final Color? color;
  final double? cornerRadius;
  final EdgeInsets padding;

  const InputFormButton(
      {super.key,
      required this.onClick,
      this.titleText,
      this.icon,
      this.color,
      this.cornerRadius,
      this.padding = const EdgeInsets.symmetric(horizontal: 16)});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(padding),
        maximumSize:
            WidgetStateProperty.all<Size>(Size(double.maxFinite, 28.sp)),
        minimumSize:
            WidgetStateProperty.all<Size>(Size(double.maxFinite, 28.sp)),
        backgroundColor: WidgetStateProperty.all<Color>(
            color ?? Theme.of(context).primaryColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cornerRadius ?? 12.0)),
        ),
      ),
      child: titleText != null
          ? Text(
              titleText!,
              style: const TextStyle(color: Colors.white),
            )
          : Icon(
              Icons.edit_calendar_rounded,
              color: context.isDarkMode
                  ? AppColors.secondBackground
                  : AppColors.background,
              size: AppSize.iconMedium,
            ),
    );
  }
}
