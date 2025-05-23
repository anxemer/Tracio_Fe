import 'package:Tracio/presentation/blog/bloc/create_blog_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/extension/string_extension.dart';
import 'package:Tracio/data/auth/models/register_req.dart';
import 'package:Tracio/domain/auth/usecases/register_with_ep.dart';
import 'package:Tracio/presentation/auth/pages/login.dart';
import 'package:Tracio/presentation/auth/pages/login_phone.dart';
import 'package:Tracio/service_locator.dart';

import '../../../common/widget/button/button.dart';
import '../../../common/widget/input_text_form_field.dart';
import '../../../core/configs/theme/assets/app_images.dart';
import '../../../core/constants/app_size.dart';
import '../../../core/erorr/failure.dart';
import '../widgets/button_auth.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, this.email, this.firebaseId});
  final String? email;
  final String? firebaseId;
  final TextEditingController _fullnameCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: AppSize.textLarge.sp),
                          ),
                        ),
                      )),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontSize: AppSize.textExtraLarge.h,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Align(
                    alignment: Alignment(0, -0.2),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          InputTextFormField(
                            controller: _fullnameCon,
                            labelText: 'Fullname',
                            hint: 'Fullname',
                            prefixIcon: Icon(
                              Icons.person_outline_sharp,
                              color: Colors.black,
                            ),
                            validation: (String? val) {
                              if (val == null || val.isEmpty) {
                                return 'This field can\'t be empty';
                              }

                              return null;
                            },
                          ),

                          SizedBox(
                            height: 20.h,
                          ),
                          InputTextFormField(
                            controller: TextEditingController(text: email),
                            labelText: 'Email',
                            hint: 'Email',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                            validation: (String? val) {
                              if (val == null || val.isEmpty) {
                                return 'This field can\'t be empty';
                              }
                              if (!val.isValidEmail) {
                                return 'Please input valid email';
                              }
                              return null;
                            },
                          ),

                          SizedBox(
                            height: 20.h,
                          ),
                          InputTextFormField(
                            maxLine: 1,
                            controller: _passwordCon,
                            labelText: 'Password',
                            hint: 'Password',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.black,
                            ),
                            isSecureField: true,
                            validation: (String? val) {
                              if (val == null || val.isEmpty) {
                                return 'This field can\'t be empty';
                              }

                              return null;
                            },
                          ),

                          // SizedBox(
                          //   height: 20.h,
                          // ),
                          // _phoneField(context),
                        ],
                      ),
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
            top: 10,
            right: 0,
            child: Container(
              width: 200.w,
              height: 200.h,
              decoration: BoxDecoration(
                color: AppColors.background.withValues(alpha: .4),
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

  Widget _buttonRegister(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          var result;
          // print(firebaseId.toString());
          if (_formKey.currentState!.validate()) {
            result = await sl<RegisterWithEmailAndPassUseCase>().call(
                RegisterReq(
                    firebaseId: firebaseId.toString(),
                    fullName: _fullnameCon.text,
                    email: email.toString(),
                    password: _passwordCon.text));
          }

          result.fold((l) {
            late SnackBar snackbar;

            if (l is CredentialFailure) {
              snackbar = SnackBar(
                content: Text(
                    'Your email is not verified, please check your email or verify again.'),
                behavior: SnackBarBehavior.floating,
              );
            } else if (l is ExceptionFailure) {
              snackbar = SnackBar(
                content:
                    Text(l.message ?? 'Register failed with unexpected error'),
                behavior: SnackBarBehavior.floating,
              );
            } else {
              snackbar = SnackBar(
                content: Text('Register Failure! Please try again'),
                behavior: SnackBarBehavior.floating,
              );
            }

            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          }, (r) {
            Future.microtask(() {
              AppNavigator.pushReplacement(context, LoginPage());
            });
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
          image: AppImages.logoGg,
          fillColor: Colors.white,
          textColor: Colors.black,
          borderColor: Colors.green,
          iconSize: AppSize.iconSmall,
          fontSize: AppSize.textMedium,
        ),
      ],
    );
  }
}
