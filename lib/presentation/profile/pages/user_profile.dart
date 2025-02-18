import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/common/widget/blog/header_information.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';

import '../../../common/widget/button/floating_button.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
          height: 100.h,
          hideBack: false,
          title: Text(
            'Profile',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40.sp),
          ),
          action: Row(
            children: [
              FloatingButton(
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {},
                action: Icon(
                  Icons.more_vert_outlined,
                  color: Colors.black,
                ),
              ),
              // FloatingButton(
              //   elevation: 1,
              //   backgroundColor: Colors.white,
              //   onPressed: () {},
              //   action: Icon(
              //     Icons.chat_bubble_outline,
              //     color: Colors.black,
              //   ),
              // ),
              // FloatingButton(
              //   elevation: 1,
              //   backgroundColor: Colors.white,
              //   onPressed: () async {
              //     var data = await sl<LogoutUseCase>().call();

              //     AppNavigator.pushReplacement(context, LoginPage());
              //   },
              //   action: Icon(
              //     Icons.search_outlined,
              //     color: Colors.black,
              //   ),
              // ),
            ],
          )),
      body: Column(
        children: [
          Container(
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
                      'Gò Vấp, Hồ Chí Minh',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                          fontSize: 32.sp),
                    ),
                    title: Text(
                      'An Xểm',
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
                        'I am just a chill guy',
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
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            width: double.infinity,
            // height: 400.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.lightBlueAccent.withValues(alpha: .07)),
            child: Column(
              children: [
                ListTile(
                  leading: Text(
                    'Activities',
                    style:
                        TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
                Container(
                  width: 600.w,
                  height: 3.h,
                  color: Colors.grey.shade500,
                ),
                ListTile(
                  leading: Text(
                    'Statistics',
                    style:
                        TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
                Container(
                  width: 600.w,
                  height: 3.h,
                  color: Colors.grey.shade500,
                ),
                ListTile(
                  leading: Text(
                    'routesa',
                    style:
                        TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
                Container(
                  width: 600.w,
                  height: 3.h,
                  color: Colors.grey.shade500,
                ),
                ListTile(
                  leading: Text(
                    'Blogs',
                    style:
                        TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w600),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
                // Container(
                //   width: 600.w,
                //   height: 3.h,
                //   color: Colors.grey.shade500,
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
