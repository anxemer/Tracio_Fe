import 'package:Tracio/core/erorr/failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/core/configs/theme/assets/app_images.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/auth/bloc/authCubit/auth_cubit.dart';
import 'package:Tracio/presentation/auth/pages/login.dart';
import 'package:Tracio/presentation/shop_owner/page/dash_board.dart';
import 'package:Tracio/common/widget/navbar/bottom_nav_bar_manager.dart';

import '../../auth/bloc/authCubit/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().refreshToken();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedOut || state is AuthFailure) {
            AppNavigator.pushReplacement(context, LoginPage());
          }
          if (state is AuthLoaded) {
            context.read<AuthCubit>().sendFcm();

            if (state.user?.role == 'user') {
              AppNavigator.pushReplacement(context, BottomNavBarManager());
            } else if (state.user?.role == 'shop_owner') {
              AppNavigator.pushReplacement(context, DashboardScreen());
            }
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
