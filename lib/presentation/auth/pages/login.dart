import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/button/button.dart';
import 'package:tracio_fe/common/widget/input_text_form_field.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/extension/string_extension.dart';
import 'package:tracio_fe/data/auth/models/login_req.dart';
import 'package:tracio_fe/presentation/auth/bloc/authCubit/auth_cubit.dart';
import 'package:tracio_fe/presentation/auth/pages/login_phone.dart';
import 'package:tracio_fe/presentation/auth/pages/verify_email.dart';
import 'package:tracio_fe/presentation/auth/widgets/button_auth.dart';
import 'package:tracio_fe/presentation/auth/widgets/input_field_auth.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../../common/widget/navbar/bottom_nav_bar_manager.dart';
import '../bloc/authCubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passCon = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            EasyLoading.show(status: 'Loading...');
          } else if (state is AuthLoaded) {
            if (sl<SharedPreferences>().getString('USER') != null) {
              Future.microtask(
                () {
                  EasyLoading.dismiss();
                  AppNavigator.pushReplacement(context, BottomNavBarManager());
                },
              );
            }
          } else if (state is AuthFailure) {
            if (state.failure is CredentialFailure) {
              EasyLoading.showError("Username/Password Wrong!");
            } else {
              EasyLoading.showError("Error");
            }
          } else if (state is AuthLoggedOut) {
            Future.microtask(() {
              AppNavigator.pushAndRemove(context, LoginPage());
            });
          }
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSize.textExtraLarge.sp,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            InputTextFormField(
                              controller: _emailCon,
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
                              textInputAction: TextInputAction.next,
                            ),

                            SizedBox(
                              height: 10.h,
                            ),
                            InputTextFormField(
                              controller: _passCon,
                              labelText: 'Password',
                              hint: 'Password',
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
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

                            SizedBox(
                              height: 5.h,
                            ),
                            _forgotPassText(),
                            _buttonSignIn(context),
                            SizedBox(
                              height: 10.h,
                            ),
                            _dividerWithText(),
                            SizedBox(
                              height: 10.h,
                            ),
                            _anotherLogin(),
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
          ),
        ));
  }

  Widget _logoDisplay(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.apSectionPadding * 1.4),
      child: Container(
        height: MediaQuery.of(context).size.height / 5,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(AppImages.logo))),
      ),
    );
  }

  Widget _forgotPassText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {},
            child: Text(
              'Forgot your password?',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(.5),
                  fontSize: AppSize.textMedium.sp),
            ))
      ],
    );
  }

  Widget _buttonSignIn(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if (_formKey.currentState!.validate()) {
            context.read<AuthCubit>().login(
                LoginReq(email: _emailCon.text, password: _passCon.text));
          }
        },
        child:
            ButtonAuth(title: 'Sign In', icon: Icons.arrow_forward_outlined));
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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "or sign in with",
            style:
                TextStyle(color: Colors.black, fontSize: AppSize.textMedium.sp),
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
          width: AppSize.cardWidth.w,
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

  Widget _registerText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: TextStyle(
              fontSize: AppSize.textMedium.sp,
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
              AppNavigator.pushReplacement(context, VerifyEmailpage());
            },
            child: Text(
              'Register',
              style: TextStyle(
                  fontSize: AppSize.textMedium.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.secondBackground),
            ))
      ],
    );
  }
}
