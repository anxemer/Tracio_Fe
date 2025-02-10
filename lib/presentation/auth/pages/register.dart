import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/presentation/auth/pages/login.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/assets/app_images.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Nền màu cam và Container chứa nội dung
          Container(
            width: size.width,
            height: size.height,
            color: const Color.fromARGB(255, 255, 255, 255), // Màu nền tổng thể
          ),

          // Container chính chứa nội dung
          Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Container(
              height: size.height,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: .5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          AppNavigator.pushReplacement(context, LoginPage());
                        },
                        splashColor:
                            Colors.black.withOpacity(0.3), // Màu hiệu ứng
                        borderRadius:
                            BorderRadius.circular(8), // Bo góc hiệu ứng
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.w, horizontal: 12.h),
                          child: Text(
                            "← Back to login",
                            style:
                                TextStyle(color: Colors.black, fontSize: 24.sp),
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 60.h,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.2),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        _fullnameField(context),
                        SizedBox(
                          height: 20.h,
                        ),
                        _emailField(context),

                        SizedBox(
                          height: 20.h,
                        ),
                        _passwordField(context),

                        SizedBox(
                          height: 20.h,
                        ),
                        // _phoneField(context),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, 0.5),
                    child: Column(
                      children: [
                        SizedBox(height: 30.h),
                        _buttonRegister(context),
                        SizedBox(
                          height: 20.h,
                        ),
                        _dividerWithText(),
                        SizedBox(
                          height: 20.h,
                        ),
                        _anotherLogin()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Hình tròn ở góc trên bên phải
          Positioned(
            top: 30,
            right: 0,
            child: Container(
              width: 300.w,
              height: 300.h,
              decoration: BoxDecoration(
                color: AppColors.background,
                // Màu cam giống trong ảnh
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200), // Bo tròn một góc
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fullnameField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        // color: AppColors.secondBackground,
        // height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 15))
        ]),
        child: TextField(
          decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              hintText: 'Full name',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 15)),
        ),
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        // color: AppColors.secondBackground,
        // height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 15))
        ]),
        child: TextField(
          decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: Colors.black,
              ),
              suffixIcon: Icon(Icons.remove_red_eye_outlined),
              hintText: 'Password',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 15)),
        ),
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        // color: AppColors.secondBackground,
        // height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 15))
        ]),
        child: TextField(
          decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.black,
              ),
              hintText: 'Email',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 15)),
        ),
      ),
    );
  }

  Widget _phoneField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Container(
        // color: AppColors.secondBackground,
        // height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 15,
              spreadRadius: 2,
              offset: Offset(0, 15))
        ]),
        child: TextField(
          decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(
                Icons.phone,
                color: Colors.black,
              ),
              hintText: 'Phone Number',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 15)),
        ),
      ),
    );
  }

  Widget _buttonRegister(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              width: 1.5,
              color: AppColors.primary,
              strokeAlign: BorderSide.strokeAlignOutside,
              style: BorderStyle.solid),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Center(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Register',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(Icons.arrow_forward_outlined)
            ],
          )),
        ),
      ),
    );
  }

  Widget _dividerWithText() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.black, // Màu của đường kẻ
            thickness: 1, // Độ dày
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "or create accoount usingg social media",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.black,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _anotherLogin() {
    return Column(
      children: [
        ButtonDesign(
          ontap: () {},
          text: "Google",
          icon: AppImages.logoGg,
          fillColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.green,
        ),
        SizedBox(height: 20.h),
        ButtonDesign(
          ontap: () {},
          text: "Phone Number",
          icon: AppImages.logoPhone,
          fillColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.black,
        ),
      ],
    );
  }

  Widget _logoLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            heroTag: 'btn1',
            onPressed: () {},
            backgroundColor: Colors.white.withOpacity(.1),
            shape: CircleBorder(),
            child: Image.asset(
              AppImages.logoFb,
              // width: 30,
              // height: 30,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 40,
          height: 40,
          child: FloatingActionButton(
            heroTag: 'btn2',
            onPressed: () {},
            backgroundColor: Colors.white,
            shape: CircleBorder(),
            child: Image.asset(
              AppImages.logoGg,
              // width: 30,
              // height: 30,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}
