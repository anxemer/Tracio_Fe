import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/common/widget/button/text_button.dart';
import 'package:tracio_fe/data/user/models/user_profile_model.dart';
import 'package:tracio_fe/domain/auth/entities/user.dart';
import 'package:tracio_fe/domain/user/entities/user_profile_entity.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key, required this.user});
  final UserProfileEntity user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   leading: Padding(
      //     padding:  EdgeInsets.only(left: 8),
      //     child: Center(child: BasicTextButton(text: 'Cancel', onPress: () {})),
      //   ),
      //   title: Text(
      //     'Profile',
      //     style: TextStyle(
      //       fontSize: 40.sp,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   actions: [
      //     Padding(
      //       padding: EdgeInsets.only(right: 8),
      //       child: BasicTextButton(text: 'Save', onPress: () {}),
      //     )
      //   ],
      // ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BasicTextButton(text: 'Cancel', onPress: () {}),
                Text(
                  'Profile',
                  style:
                      TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
                ),
                BasicTextButton(text: 'Save', onPress: () {}),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipOval(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(60.sp)),
                  width: 200.w,
                  height: 200.h,
                  child: CachedNetworkImage(
                    imageUrl: user.profilePicture!,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Container(
                  // decoration: BoxDecoration(color: Colors.black),
                  height: 150.h,
                  width: 350.w,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'user Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          )),
                    ),
                  ))
            ],
          )
        ],
      )),
    );
  }
}
