import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/domain/blog/entites/blog.dart';

import '../../../core/configs/theme/assets/app_images.dart';
import '../../../presentation/blog/widget/react_blog.dart';

class PostBlog extends StatelessWidget {
  const PostBlog({super.key, required this.blogEntity, this.morewdget});
  final BlogEntity blogEntity;
  final Widget? morewdget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.lightBlueAccent.withValues(alpha: .1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _informationPost(),
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                blogEntity.content.toString(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlueAccent.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(20)),
              height: 600.h,
              width: 750.w,
              child: Image.asset(
                AppImages.picture,
                fit: BoxFit.fill,
              ),
              // color: Colors.black,
            ),
            // _reactBlog(),
            ReactBlog(
              blogEntity: blogEntity,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'view all 200 comments',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            morewdget ?? Container()
          ],
        ),
      ),
    );
    ;
  }

  Widget _informationPost() {
    return SizedBox(
        width: 750.w,
        height: 100.h,
        child: Center(
          child: ListTile(
            leading: ClipOval(
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(60.sp)),
                width: 80.w,
                // height: 100.h,
                child: Image.asset(
                  AppImages.man,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            title: Text(
              blogEntity.userName.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 28.sp),
            ),
            subtitle: Text(
              'AnXemer',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 20.sp),
            ),
            trailing: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ));
  }
}
