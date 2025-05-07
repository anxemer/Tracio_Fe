import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/constants/app_size.dart';

import '../../../core/configs/theme/app_colors.dart';

class ButtonAuth extends StatelessWidget {
  const ButtonAuth({super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.secondBackground,
        borderRadius: BorderRadius.circular(AppSize.borderRadiusMedium.sp),
        border: Border.all(
            width: 1.5,
            color: AppColors.primary,
            strokeAlign: BorderSide.strokeAlignOutside,
            style: BorderStyle.solid),
      ),
      child: Center(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.textLarge.sp,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10.w,
          ),
          Icon(
            icon,
            color: Colors.white,
          )
        ],
      )),
    );
  }
}
