import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';

class ListReact extends StatefulWidget {
  const ListReact({super.key});

  @override
  State<ListReact> createState() => _ListReactState();
}

class _ListReactState extends State<ListReact> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r), topRight: Radius.circular(32.r)),
      child: Container(
        color: Colors.white,
        height: 300.h,
        child: Stack(
          children: [
            Positioned(
              top: 8.h,
              left: 260.w,
              child: Container(
                width: 200.w,
                height: 3.h,
                color: Colors.black,
              ),
            ),
            ListView.builder(
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
                  child: _reactItem(),
                );
              },
            ),
            // Positioned(bottom: 0, right: 0, left: 0, child: _comment())
          ],
        ),
      ),
    );
  }

  Widget _reactItem() {
    return Container(
      decoration: BoxDecoration(
          // color: AppColors.background.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: ClipOval(
          child: SizedBox(
            width: 40.w,
            height: 40.h,
            child: Image.asset(AppImages.man),
          ),
        ),
        title: Text(
          'AnXemer',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
