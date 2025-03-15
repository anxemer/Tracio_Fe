import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/auth/pages/login.dart';
import 'package:tracio_fe/presentation/splash/bloc/splash_cubit.dart';
import 'package:tracio_fe/common/widget/navbar/bottom_nav_bar_manager.dart';

import '../bloc/splash_state.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            AppNavigator.pushReplacement(context, LoginPage());
          }
          if (state is Authenticated) {
            AppNavigator.pushReplacement(context, BottomNavBarManager());
          }
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(AppImages.topright),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                AppImages.logo2,
                width: AppSize.imageExtraLarge,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset(AppImages.bottomleft),
            ),
          ],
        ),
      ),
    );
  }
}
