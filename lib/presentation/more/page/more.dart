import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:Tracio/domain/auth/entities/user.dart' show UserEntity;
import 'package:Tracio/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/presentation/library/pages/library.dart';
import 'package:Tracio/presentation/auth/pages/login.dart';
import 'package:Tracio/presentation/map/pages/route_planner.dart';

import '../../auth/bloc/authCubit/auth_cubit.dart';
import '../../auth/bloc/authCubit/auth_state.dart';
import '../../profile/pages/user_profile.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    UserEntity? user = sl<AuthLocalSource>().getUser();

    // if (state is AuthLoaded) {
    //   user = state.user!;
    // } else if (state is AuthChangeRole) {
    //   user = state.user!;
    // }
    return Scaffold(
        appBar: BasicAppbar(
          title: Text(
            'More',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: AppSize.textHeading * 0.9.sp,
            ),
          ),
          hideBack: true,
        ),
        body: ListView(children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CirclePicture(
                  imageUrl: user?.profilePicture ?? '',
                  imageSize: AppSize.iconLarge),
              // CircleAvatar(
              //   backgroundImage:
              //       NetworkImage(user.profilePicture),
              //   radius: 20.w,
              // ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Profile'),
                  Text(
                    user?.email ?? '',
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
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.library_books, color: Colors.black54),
            title: Text('Library'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LibraryPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.people, color: Colors.black54),
            title: Text('Follows'),
            onTap: () {
              Navigator.pushNamed(context, '/follows');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.photo, color: Colors.black54),
            title: Text('Photos'),
            onTap: () {
              Navigator.pushNamed(context, '/photos');
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
              // await sl<LogoutUseCase>().call(NoParams());
              // Navigator.pushNamed(context, '/logout');
            },
          ),
        ]));
  }
}
