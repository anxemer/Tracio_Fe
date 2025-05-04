import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/common/widget/dialog_confirm.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/data/auth/models/change_role_req.dart';
import 'package:tracio_fe/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:tracio_fe/main.dart';
import 'package:tracio_fe/presentation/auth/pages/login.dart';
import 'package:tracio_fe/presentation/map/pages/route_planner.dart';
import 'package:tracio_fe/presentation/shop_owner/page/shop_profile_management.dart';
import 'package:tracio_fe/presentation/splash/page/splash.dart';
import 'package:tracio_fe/service_locator.dart';

import '../../../common/widget/picture/circle_picture.dart';
import '../../auth/bloc/authCubit/auth_cubit.dart';
import '../../auth/bloc/authCubit/auth_state.dart';
import '../../map/bloc/map_cubit.dart';

class TabMorePage extends StatelessWidget {
  const TabMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()..checkUser(),
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            'More',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: AppSize.textHeading.sp,
            ),
          ),
          hideBack: true,
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthLoaded) {
              return ListView(
                children: [
                  ListTile(
                    leading: CirclePicture(
                        imageUrl: state.user!.profilePicture!,
                        imageSize: AppSize.iconLarge),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Profile'),
                        Text(
                          state.user!.email!,
                          style: TextStyle(
                            fontSize: AppSize.textSmall.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.library_books, color: Colors.black54),
                    title: Text('Your Shop'),
                    onTap: () async {
                      print(state.user!.countRole!.runtimeType);
                      var refreshToken =
                          await sl<AuthLocalSource>().getRefreshToken();
                      if (state.user!.countRole! == "2") {
                        context.read<AuthCubit>().changeRole(ChangeRoleReq(
                            refreshToken: refreshToken, role: 'shop'));
                      } else {
                        DialogConfirm(
                                btnLeft: () => Navigator.pop(context),
                                btnRight: () {
                                  AppNavigator.push(
                                    context,
                                    BlocProvider<MapCubit>(
                                      create: (context) => MapCubit(),
                                      child: ShopProfileManagementScreen(),
                                    ),
                                  );
                                },
                                notification:
                                    'You don\'t have a store! DO you wan\'t create your store',
                                textLeft: 'No',
                                textRight: 'Yes')
                            .showDialogConfirmation(context);
                      }
                    },
                  ),
                  // Divider(),
                  // ListTile(
                  //   leading: Icon(Icons.people, color: Colors.black54),
                  //   title: Text('Follows'),
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/follows');
                  //   },
                  // ),
                  // Divider(),
                  // ListTile(
                  //   leading: Icon(Icons.photo, color: Colors.black54),
                  //   title: Text('Photos'),
                  //   onTap: () {
                  //     Navigator.pushNamed(context, '/photos');
                  //   },
                  // ),
                  // Divider(),
                  ListTile(
                    leading: Icon(Icons.directions, color: Colors.black54),
                    title: Text('Route Planner'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RoutePlanner()),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.help, color: Colors.black54),
                    title: Text('Help Center'),
                    onTap: () {
                      Navigator.pushNamed(context, '/help-center');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.contact_mail, color: Colors.black54),
                    title: Text('Contact Us'),
                    onTap: () {
                      Navigator.pushNamed(context, '/contact-us');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.settings, color: Colors.black54),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.black54),
                    title: Text('Log Out'),
                    onTap: () {
                      context.read<AuthCubit>().logout();
                      AppNavigator.pushAndRemove(context, LoginPage());
                      // await sl<LogoutUseCase>().call(NoParams());
                      // Navigator.pushNamed(context, '/logout');
                    },
                  ),
                ],
              );
            } else if (state is AuthChangeRole) {
              Future.microtask(() {
                AppNavigator.pushAndRemove(context, SplashPage());
              });
            }
            return Container();
          },
        ),
      ),
    );
  }
}
