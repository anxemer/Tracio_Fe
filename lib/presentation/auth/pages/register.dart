import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/data/auth/models/register_req.dart';
import 'package:tracio_fe/domain/auth/usecases/register_with_ep.dart';
import 'package:tracio_fe/presentation/auth/pages/login.dart';
import 'package:tracio_fe/presentation/auth/pages/login_phone.dart';
import 'package:tracio_fe/presentation/home/pages/home.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../widgets/button_auth.dart';
import '../widgets/input_field_auth.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, this.email, this.firebaseId});
  final String? email;
  final String? firebaseId;
  final TextEditingController _fullnameCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
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
                          AppNavigator.push(context, LoginPage());
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
                        InputFieldAuth(
                            textController: _fullnameCon,
                            hintText: 'Fullname',
                            prefixIcon: Icon(
                              Icons.person_outline_sharp,
                              color: Colors.black,
                            )),
                        SizedBox(
                          height: 20.h,
                        ),
                        InputFieldAuth(
                            enale: false,
                            textController: TextEditingController(text: email),
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            )),

                        SizedBox(
                          height: 20.h,
                        ),
                        InputFieldAuth(
                          obscureText: true,
                          textController: _passwordCon,
                          suffixIconl: Icon(Icons.remove_red_eye_outlined),
                          hintText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.black,
                          ),
                        ),

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
                        _anotherLogin(context)
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

  Widget _phoneField(
    BuildContext context,
  ) {
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
        onTap: () async {
          var result = await sl<RegisterWithEmailAndPassUseCase>().call(
              params: RegisterReq(
                  firebaseId: firebaseId.toString(),
                  fullName: _fullnameCon.text,
                  email: email.toString(),
                  password: _passwordCon.text));
          result.fold((l) {
            var snackbar = SnackBar(
              content: Text(l),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }, (r) {
            Future.microtask(
              () {
                AppNavigator.pushReplacement(context, HomePage());
              },
            );
          });
        },
        child:
            ButtonAuth(title: 'Register', icon: Icons.arrow_forward_outlined));
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

  Widget _anotherLogin(BuildContext context) {
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
          ontap: () {
            AppNavigator.push(context, LoginPhone());
          },
          text: "Phone Number",
          icon: AppImages.logoPhone,
          fillColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.black,
        ),
      ],
    );
  }
}
