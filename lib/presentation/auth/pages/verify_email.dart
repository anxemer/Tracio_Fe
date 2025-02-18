import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/presentation/auth/bloc/verify_email/verify_email_cubit.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../bloc/verify_email/verify_email_state.dart';
import '../widgets/button_auth.dart';
import '../widgets/input_field_auth.dart';
import 'login.dart';
import 'register.dart';

class VerifyEmailpage extends StatelessWidget {
  VerifyEmailpage({super.key});
  final TextEditingController _emailCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => VerifyEmailCubit(),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
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
                        InputFieldAuth(
                          textController: _emailCon,
                          suffixIconl: Icon(Icons.remove_red_eye_outlined),
                          hintText: 'Email',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),

                        // _forgotPassText(),
                        BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
                          builder: (context, state) {
                            if (state is VerifyEmailSuccess) {
                              Future.microtask(() {
                                AppNavigator.pushReplacement(
                                    context,
                                    RegisterPage(
                                      email: _emailCon.text,
                                      firebaseId: state.firebaseId,
                                    ));
                              });
                            }
                            if (state is VerifyEmailFailure) {
                              return Column(
                                children: [
                                  _buttonSignIn(
                                      context, _emailCon.text.toString()),
                                  Text(
                                    'Verify failure, please try again',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18.sp),
                                  ),
                                ],
                              );
                            }
                            return _buttonSignIn(
                                context, _emailCon.text.toString().trim());
                          },
                        ),

                        SizedBox(
                          height: 10.h,
                        ),

                        // _registerText(context)
                      ],
                    ),
                  )),
            ],
          ),
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

  Widget _buttonSignIn(BuildContext context, String email) {
    return BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
      builder: (context, state) {
        if (state is VerifyEmailLoading) {
          return const CircularProgressIndicator(); // Hiển thị loading khi đang xử lý
        }

        return GestureDetector(
          onTap: () async {
            context.read<VerifyEmailCubit>().verifyEmail(email.trim());
          },
          child: ButtonAuth(
            title: 'Verify Email',
            icon: Icons.arrow_forward_outlined,
          ),
        );
      },
    );
  }

  // Widget _registerText(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text(
  //         'Don\'t have an account?',
  //         style: TextStyle(
  //             fontSize: 24.sp,
  //             color: Colors.black,
  //             fontWeight: FontWeight.w500),
  //       ),
  //       TextButton(
  //           style: ButtonStyle(
  //             overlayColor: WidgetStateProperty.resolveWith<Color?>(
  //               (Set<WidgetState> states) {
  //                 if (states.contains(WidgetState.pressed)) {
  //                   return Colors.black.withOpacity(0.2); // Màu khi nhấn
  //                 }
  //                 return null;
  //               },
  //             ),
  //           ),
  //           onPressed: () {
  //             AppNavigator.push(context, RegisterPage());
  //           },
  //           child: Text(
  //             'Register',
  //             style: TextStyle(
  //                 fontSize: 24.sp,
  //                 fontWeight: FontWeight.w500,
  //                 color: AppColors.secondBackground),
  //           ))
  //     ],
  //   );
  // }
}
