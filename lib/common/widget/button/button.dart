import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonDesign extends StatelessWidget {
  const ButtonDesign(
      {super.key,
      required this.ontap,
      required this.text,
      required this.icon,
      required this.fillColor,
      required this.textColor,
      required this.borderColor});
  final VoidCallback ontap;
  final String text;
  final String icon;
  final Color fillColor;
  final Color textColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      width: 500.w,
      child: InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(20.r), // Tự động co giãn
        child: Container(
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              width: 1.5.w,
              color: borderColor,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icon, width: 40.w, height: 40.h),
                SizedBox(width: 10.w),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 24.sp, // Tự động điều chỉnh theo màn hình
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
