import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/constants/app_size.dart';

class ButtonDesign extends StatelessWidget {
  const ButtonDesign(
      {super.key,
      required this.ontap,
      this.text,
      this.image,
      required this.fillColor,
      this.textColor,
      required this.borderColor,
      this.height,
      this.width,
      this.iconSize,
      required this.fontSize,
      this.icon});
  final VoidCallback ontap;
  final String? text;
  final String? image;
  final Color fillColor;
  final Color? textColor;
  final Color borderColor;
  final double? height;
  final double? width;
  final double? iconSize;
  final double fontSize;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      // borderRadius: BorderRadius.circular(20.r), // Tự động co giãn
      child: Container(
        height: height ?? 40.h,
        width: width ?? 140.w,
        // padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(AppSize.borderRadiusMedium),
          border: Border.all(
            width: 1.5.w,
            color: borderColor,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? icon!
                : (image != null
                    ? Image.asset(image!,
                        width: iconSize!.w, height: iconSize!.h)
                    : Container()),
            // SizedBox(
            //   width: 10.w,
            // ),
            SizedBox(width: 4.w),
            Text(
              text ?? '',
              style: TextStyle(
                fontSize: fontSize.sp, // Tự động điều chỉnh theo màn hình
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
