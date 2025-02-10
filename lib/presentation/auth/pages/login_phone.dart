import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/helper/navigator/app_navigator.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import 'login.dart';
import 'register.dart';

class LoginPhone extends StatelessWidget {
  const LoginPhone({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _logoDisplay(context),
            Container(
                height: size.height * 1.3.h,
                width: size.width,
                decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(.5),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              AppNavigator.pushReplacement(
                                  context, LoginPage());
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 24.sp),
                              ),
                            ),
                          )),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 60.sp,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      _phoneNumberField(context),
                      SizedBox(
                        height: 30.h,
                      ),

                      // _forgotPassText(),
                      _buttonSignIn(context),
                      SizedBox(
                        height: 10.h,
                      ),
                      // _dividerWithText(),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      // // _anotherLogin(),
                      // SizedBox(
                      //   height: 10.h,
                      // ),
                      _registerText(context)
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _logoDisplay(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.8,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(AppImages.logo))),
    );
  }

  Widget _phoneNumberField(BuildContext context) {
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
              hintText: 'Enter Phone Number',
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 15)),
        ),
      ),
    );
  }

  // Widget _passwordField(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //     child: Container(
  //       // color: AppColors.secondBackground,
  //       // height: MediaQuery.of(context).size.height,
  //       decoration: BoxDecoration(boxShadow: [
  //         BoxShadow(
  //             color: Colors.black.withOpacity(.2),
  //             blurRadius: 15,
  //             spreadRadius: 2,
  //             offset: Offset(0, 15))
  //       ]),
  //       child: TextField(
  //         decoration: InputDecoration(
  //             filled: true,
  //             prefixIcon: Icon(
  //               Icons.lock_outline_rounded,
  //               color: Colors.black,
  //             ),
  //             suffixIcon: Icon(Icons.remove_red_eye_outlined),
  //             hintText: 'Password',
  //             fillColor: Colors.white,
  //             contentPadding: EdgeInsets.symmetric(vertical: 15)),
  //       ),
  //     ),
  //   );
  // }

  // Widget _forgotPassText() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       TextButton(
  //           onPressed: () {},
  //           child: Text(
  //             'Forgot your password?',
  //             style: TextStyle(
  //                 fontWeight: FontWeight.w500,
  //                 color: Colors.black.withOpacity(.5),
  //                 fontSize: 24.sp),
  //           ))
  //     ],
  //   );
  // }

  Widget _buttonSignIn(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 300.w,
        height: 120.h,
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
                'Send OTP',
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 10.w,
              ),
              Icon(Icons.arrow_forward_outlined)
            ],
          )),
        ),
      ),
    );
  }

  // Widget _dividerWithText() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: Divider(
  //           color: Colors.black, // Màu của đường kẻ
  //           thickness: 1, // Độ dày
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10),
  //         child: Text(
  //           "or sign in with",
  //           style: TextStyle(color: Colors.black, fontSize: 24.sp),
  //         ),
  //       ),
  //       Expanded(
  //         child: Divider(
  //           color: Colors.black,
  //           thickness: 1,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _anotherLogin() {
  //   return Column(
  //     children: [
  //       ButtonDesign(
  //         ontap: () {},
  //         text: "Google",
  //         icon: AppImages.logoGg,
  //         fillColor: Colors.white,
  //         textColor: Colors.black,
  //         borderColor: Colors.green,
  //       ),
  //       SizedBox(height: 20.h), // Khoảng cách tự động co giãn
  //       ButtonDesign(
  //         ontap: () {},
  //         text: "Phone Number",
  //         icon: AppImages.logoPhone,
  //         fillColor: Colors.white,
  //         textColor: Colors.black,
  //         borderColor: Colors.black,
  //       ),
  //     ],
  //   );
  // }

  Widget _registerText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(
              fontSize: 24.sp,
              color: Colors.black,
              fontWeight: FontWeight.w500),
        ),
        TextButton(
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    return Colors.black.withOpacity(0.2); // Màu khi nhấn
                  }
                  return null;
                },
              ),
            ),
            onPressed: () {
              AppNavigator.push(context, RegisterPage());
            },
            child: Text(
              'Register',
              style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondBackground),
            ))
      ],
    );
  }
}
