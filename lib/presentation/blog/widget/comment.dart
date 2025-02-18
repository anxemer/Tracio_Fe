import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';

class Comment extends StatefulWidget {
  const Comment({super.key});

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
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
                      EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.h),
                  child: _commentItem(),
                );
              },
            ),
            Positioned(bottom: 0, right: 0, left: 0, child: _comment())
          ],
        ),
      ),
    );
  }

  Widget _comment() {
    return //Comments
        Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.h),
      child: Row(
        children: [
          // Container(
          //   decoration:
          //       BoxDecoration(borderRadius: BorderRadius.circular(60.sp)),
          //   width: 80.w,
          //   // height: 100.h,
          //   child: Image.asset(
          //     AppImages.man,
          //     fit: BoxFit.fill,
          //   ),
          // ),
          // SizedBox(
          //   width: 10.w,
          // ),
          Expanded(
            // height: MediaQuery.of(context).size.height,

            child: TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  filled: true,
                  hintText: 'Add a comment',
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 15)),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Icon(
            Icons.send_rounded,
            color: AppColors.background,
            size: 30,
          )
        ],
      ),
    );
  }

  Widget _commentItem() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: .2),
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
        subtitle: Text(
          'AnXemer dep trai bip pro',
          style: TextStyle(
            fontSize: 32.sp,
            color: Colors.black,
          ),
        ),
        trailing: Icon(Icons.favorite_border),
      ),
    );
  }
}
