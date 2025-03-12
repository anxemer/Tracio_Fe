import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';

import '../../../common/widget/blog/header_information.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';

class Userinformation extends StatelessWidget {
  const Userinformation({super.key, required this.user});
  final UserProfileEntity user;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.lightBlueAccent.withValues(alpha: .07)),
      child: Column(
        children: [
          HeaderInformation(
              widthImage: 120.w,
              subtitle: Text(
                '${user.district} ${user.city!}',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: 32.sp),
              ),
              title: Text(
                user.userName!,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.sp),
              ),
              imageUrl: Image.asset(AppImages.man),
              trailling: SizedBox(
                child: Image.asset(AppImages.edit),
                width: 40.w,
              )),
          SizedBox(
            height: 40.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.bio!,
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w400,
                      fontSize: 24.sp),
                ),
                SizedBox(
                  width: 300.w,
                  height: 100.h,
                  // color: Colors.black,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Beginner',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10)),
                          width: double.infinity,
                          height: 20.h,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '50/100',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Following'),
                    Text(
                      '89',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 32.sp),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Follower'),
                    Text(
                      '89',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 32.sp),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ACtivities'),
                    Text(
                      '89',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 32.sp),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Challenges'),
                    Text(
                      '89',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 32.sp),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Blogs'),
                    Text(
                      '89',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 32.sp),
                    )
                  ],
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
