import 'package:Tracio/presentation/profile/pages/user_profile.dart';
import 'package:Tracio/presentation/shop_owner/bloc/shop_profile/shop_profile_manage/shop_profile_manage_cubit.dart';
import 'package:Tracio/presentation/shop_owner/page/dash_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/dialog_confirm.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/data/auth/models/change_role_req.dart';
import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:Tracio/presentation/auth/pages/login.dart';
import 'package:Tracio/presentation/map/pages/route_planner.dart';
import 'package:Tracio/presentation/shop_owner/page/shop_profile_management.dart';
import 'package:Tracio/service_locator.dart';

import '../../../common/widget/picture/circle_picture.dart';
import '../../../domain/auth/entities/user.dart';
import '../../auth/bloc/authCubit/auth_cubit.dart';
import '../../auth/bloc/authCubit/auth_state.dart';
import '../../map/bloc/map_cubit.dart';
import '../../splash/page/splash.dart';

class TabMorePage extends StatefulWidget {
  const TabMorePage({super.key});

  @override
  State<TabMorePage> createState() => _TabMorePageState();
}

class _TabMorePageState extends State<TabMorePage> {
  @override
  Widget build(BuildContext context) {
    UserEntity? user = sl<AuthLocalSource>().getUser();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthChangeRole) {
          Future.microtask(() {
            AppNavigator.pushAndRemove(context, DashboardScreen());
          });
        }
      },
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
          body: ListView(
            children: [
              ListTile(
                leading: CirclePicture(
                    imageUrl: user!.profilePicture!,
                    imageSize: AppSize.iconLarge),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('My Profile'),
                    Text(
                      user.email!,
                      style: TextStyle(
                        fontSize: AppSize.textSmall.sp,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  AppNavigator.push(
                      context,
                      UserProfilePage(
                        userId: user?.userId,
                        myProfile: true,
                      ));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.library_books, color: Colors.black54),
                title: Text('Your Shop'),
                onTap: () async {
                  var refreshToken =
                      await sl<AuthLocalSource>().getRefreshToken();
                  if (user!.countRole == "2") {
                    context.read<AuthCubit>().changeRole(ChangeRoleReq(
                        refreshToken: refreshToken, role: 'shop'));
                  } else {
                    DialogConfirm(
                            btnLeft: () => Navigator.pop(context),
                            btnRight: () {
                              AppNavigator.push(
                                context,
                                MultiBlocProvider(
                                  providers: [
                                    BlocProvider<MapCubit>(
                                      create: (context) => MapCubit(),
                                    ),
                                    BlocProvider(
                                      create: (context) =>
                                          ShopProfileManageCubit(),
                                    ),
                                  ],
                                  child: ShopProfileManagementScreen(
                                    isEditing: false,
                                  ),
                                ),
                              );
                            },
                            notification:
                                'You don\'t have a store! Do you want to create your store?',
                            textLeft: 'No',
                            textRight: 'Yes')
                        .showDialogConfirmation(context);
                  }
                },
              ),
              Divider(),
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
                },
              ),
            ],
          )),
    );
  }
}
