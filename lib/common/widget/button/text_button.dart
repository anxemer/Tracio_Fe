import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/constants/app_size.dart';

class BasicTextButton extends StatelessWidget {
  const BasicTextButton(
      {super.key,
      required this.text,
      required this.onPress,
      this.borderColor,
      this.fontSize});
  final String text;
  final VoidCallback onPress;
  final Color? borderColor;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
            border: Border.all(color: borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: fontSize ?? AppSize.textMedium.sp * 1.2,
              color: context.isDarkMode ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
