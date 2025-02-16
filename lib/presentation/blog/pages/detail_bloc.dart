import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widget/appbar/app_bar.dart';
import '../../../common/widget/button/floating_button.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../widget/react_blog.dart';

class DetailBlocPage extends StatefulWidget {
  const DetailBlocPage({super.key});

  @override
  State<DetailBlocPage> createState() => _DetailBlocPageState();
}

class _DetailBlocPageState extends State<DetailBlocPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BasicAppbar(
          height: 100.h,
          hideBack: false,
          title: _informationPost(),
          // Text(
          //   'Home',
          //   style: TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 40.sp),
          // ),
          action: Row(
            children: [
              FloatingButton(
                elevation: 0,
                backgroundColor: Colors.white,
                onPressed: () {},
                action: Icon(
                  Icons.more_vert,
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
              //   onPressed: () {},
              //   action: Icon(
              //     Icons.search_outlined,
              //     color: Colors.black,
              //   ),
              // ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.w),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.lightBlueAccent.withValues(alpha: .1)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _informationPost(),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'A Flutter application to submit and view feedbacks integrated with Google Sheets, using BLoC for state management. It showcases form validation, data submission, and dynamic list rendering with efficient state handling.',
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
                // ReactBlog(),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //   child:
                //   Text(
                //     'view all 200 comments',
                //     style: TextStyle(
                //         color: Colors.black54,
                //         fontSize: 24.sp,
                //         fontWeight: FontWeight.w500),
                //   ),
                // ),
                SizedBox(
                  height: 40.h,
                ),
                //Comments
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60.sp)),
                        width: 80.w,
                        // height: 100.h,
                        child: Image.asset(
                          AppImages.man,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      _commentBlog(),
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
                ),
              ],
            ),
          ),
        ));
  }

  Widget _informationPost() {
    return SizedBox(
        width: 750.w,
        height: 800.h,
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
              'AnXemer',
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
            // trailing: Icon(Icons.arrow_forward_ios_rounded),
          ),
        ));
  }

  Widget _reactBlog() {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
            ),
            Icon(
              Icons.favorite_outline,
              color: Colors.red,
              size: 52.sp,
            ),
            SizedBox(
              width: 20.w,
            ),
            Icon(
              Icons.comment_outlined,
              color: Colors.black,
              size: 52.sp,
            ),
            SizedBox(
              width: 20.w,
            ),
            Icon(
              Icons.ios_share,
              color: Colors.black,
              size: 52.sp,
            ),
            // SizedBox(
            //   width: 400.w,
            // ),
            Spacer(),
            Icon(
              Icons.bookmark_border,
              color: Colors.black,
              size: 52.sp,
            ),
          ],
        )
      ],
    );
  }

  Widget _commentBlog() {
    return Expanded(
      // height: MediaQuery.of(context).size.height,

      child: TextField(
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
            filled: true,
            hintText: 'Add a comment',
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }
}
