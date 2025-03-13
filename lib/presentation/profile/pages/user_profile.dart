import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/data/blog/models/request/get_blog_req.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:tracio_fe/presentation/profile/bloc/user_profile_cubit.dart';
import 'package:tracio_fe/presentation/profile/bloc/user_profile_state.dart';
import 'package:tracio_fe/presentation/profile/widgets/UserInformation.dart';
import 'package:tracio_fe/presentation/profile/widgets/user_blog_list.dart';

import '../../../common/widget/button/floating_button.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key, this.userId});
  final int? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
          height: 100.h,
          hideBack: false,
          title: Text(
            'Profile',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40.sp),
          ),
          action: Row(
            children: [
              FloatingButton(
                elevation: 0,
                backgroundColor: Colors.transparent,
                onPressed: () {},
                action: Icon(
                  Icons.more_vert_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          )),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserProfileCubit()..getUserProfile(userId!),
          ),
          BlocProvider(
            create: (context) => GetBlogCubit()
              ..getBlog(GetBlogReq(userId: userId.toString(), pageSize: 10)),
          ),
        ],
        child: Column(
          children: [
            BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                if (state is UserProfileLoaded) {
                  return Userinformation(
                    user: state.userProfileEntity,
                  );
                }
                return Container();
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: double.infinity,
              // height: 400.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.lightBlueAccent.withValues(alpha: .07)),
              child: Column(
                children: [
                  ListTile(
                    leading: Text(
                      'Activities',
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.w600),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                  Container(
                    width: 600.w,
                    height: 3.h,
                    color: Colors.grey.shade500,
                  ),
                  ListTile(
                    leading: Text(
                      'Statistics',
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.w600),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                  Container(
                    width: 600.w,
                    height: 3.h,
                    color: Colors.grey.shade500,
                  ),
                  ListTile(
                    leading: Text(
                      'routesa',
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.w600),
                    ),
                    trailing: Icon(Icons.navigate_next),
                  ),
                  Container(
                    width: 600.w,
                    height: 3.h,
                    color: Colors.grey.shade500,
                  ),
                  Builder(builder: (context) {
                    return InkWell(
                      onTap: () {
                        final blogCubit = context.read<GetBlogCubit>()
                          ..getBlog(GetBlogReq(
                              userId: userId.toString(), pageSize: 10));

                        AppNavigator.push(
                            context,
                            BlocProvider.value(
                                value: blogCubit,
                                child: UserBlogList(userId: userId!)));
                      },
                      child: ListTile(
                        leading: Text(
                          'Blogs',
                          style: TextStyle(
                              fontSize: 32.sp, fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(Icons.navigate_next),
                      ),
                    );
                  })

                  // Container(
                  //   width: 600.w,
                  //   height: 3.h,
                  //   color: Colors.grey.shade500,
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
