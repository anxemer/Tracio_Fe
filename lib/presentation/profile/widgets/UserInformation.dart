import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/picture/circle_picture.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';
import 'package:tracio_fe/presentation/profile/pages/edit_profile.dart';

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
          color: const Color.fromARGB(255, 255, 255, 255)),
      child: Column(
        children: [
          HeaderInformation(
              widthImage: AppSize.imageLarge.w,
              subtitle: Text(
                '${user.district} ${user.city!}',
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                    fontSize: AppSize.textLarge.sp),
              ),
              title: Text(
                user.userName!,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.textExtraLarge.sp),
              ),
              imageUrl: CirclePicture(
                  imageUrl: user.profilePicture!, imageSize: AppSize.iconLarge),
              trailling: InkWell(
                onTap: () => AppNavigator.push(
                    context,
                    EditProfilePage(
                      user: user,
                    )),
                child: SizedBox(
                  child: Image.asset(
                    AppImages.edit,
                    width: AppSize.iconMedium.w,
                  ),
                  // width: AppSize.imageSmall,
                ),
              )),
          SizedBox(
            height: 10.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.bio!,
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w400,
                      fontSize: AppSize.textLarge.sp),
                ),
                SizedBox(
                  width: 150.w,
                  height: 50.h,
                  // color: Colors.black,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Beginner',
                          style: TextStyle(
                              fontSize: AppSize.textMedium,
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
                          height: 10.h,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Following'),
                    Text(
                      '89',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.textLarge.sp),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Follower'),
                    Text(
                      '89',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.textLarge.sp),
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
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.textLarge.sp),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Challenges'),
                    Text(
                      '89',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.textLarge.sp),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Blogs'),
                    Text(
                      '89',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: AppSize.textLarge.sp),
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
