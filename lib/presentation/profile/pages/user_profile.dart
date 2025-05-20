import 'package:Tracio/common/widget/button/loading.dart';
import 'package:Tracio/presentation/profile/pages/setting_privacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/data/blog/models/request/get_blog_req.dart';
import 'package:Tracio/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:Tracio/presentation/profile/bloc/user_profile_cubit.dart';
import 'package:Tracio/presentation/profile/bloc/user_profile_state.dart';
import 'package:Tracio/presentation/profile/pages/edit_profile.dart';
import 'package:Tracio/presentation/profile/widgets/user_Information.dart';
import 'package:Tracio/presentation/profile/widgets/user_blog_list.dart';

import '../../../domain/user/entities/user_profile_entity.dart';
import '../../groups/cubit/challenge_cubit.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, this.userId, this.myProfile = true});
  final int? userId;
  final bool myProfile;
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().getUserProfile(widget.userId!);
  }

  @override
  Widget build(BuildContext context) {
    late UserProfileEntity userEntity;
    ItemUser? selectedItem;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetBlogCubit()
            ..getBlog(
                GetBlogReq(userId: widget.userId.toString(), isSeen: false)),
        ),
        BlocProvider(
          create: (context) => GetBlogCubit()..getBookmarkBlog(GetBlogReq()),
        ),
        BlocProvider(
          create: (context) => ChallengeCubit(),
        )
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: BasicAppbar(
            height: 100.h,
            title: Text(
              'Profile',
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.textExtraLarge.sp),
            ),
            action: widget.myProfile
                ? Row(
                    children: [
                      PopupMenuButton<ItemUser>(
                        iconColor: Colors.white,
                        initialValue: selectedItem,
                        onSelected: (ItemUser item) {
                          setState(() {
                            selectedItem = item;
                          });
                          if (item == ItemUser.edit) {
                            AppNavigator.push(
                                context, EditProfilePage(user: userEntity));
                          } else if (item == ItemUser.delete) {
                          } else if (item == ItemUser.accountPrivacy) {
                            AppNavigator.push(
                                context,
                                AccountPrivacyScreen(
                                  userId: userEntity.userId!,
                                  userStatus: userEntity.isPublic!,
                                ));
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<ItemUser>>[
                          const PopupMenuItem<ItemUser>(
                              value: ItemUser.edit, child: Text('Edit')),
                          const PopupMenuItem<ItemUser>(
                              value: ItemUser.delete, child: Text('Delete')),
                          const PopupMenuItem<ItemUser>(
                              value: ItemUser.accountPrivacy,
                              child: Text('Account Privacy')),
                        ],
                      ),
                      // FloatingButton(
                      //   elevation: 0,
                      //   backgroundColor: Colors.transparent,
                      //   onPressed: () {},
                      //   action: Icon(
                      //     Icons.more_vert_outlined,
                      //     color: Colors.white,
                      //     size: AppSize.iconLarge,
                      //   ),
                      // ),
                    ],
                  )
                : SizedBox.shrink()),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: BlocBuilder<UserProfileCubit, UserProfileState>(
              builder: (context, state) {
                if (state is UserProfileLoaded) {
                  userEntity = state.userProfileEntity;
                  return Column(
                    children: [
                      Userinformation(
                        myProfile: widget.myProfile,
                        user: state.userProfileEntity,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      if (userEntity.isPublic! || widget.myProfile)
                        Container(
                          width: double.infinity,
                          // height: 400.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Text(
                                  'Activities',
                                  style: TextStyle(
                                      fontSize: AppSize.textLarge.sp,
                                      fontWeight: FontWeight.w600),
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
                                      fontSize: AppSize.textLarge.sp.sp,
                                      fontWeight: FontWeight.w600),
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
                                  'Routes',
                                  style: TextStyle(
                                      fontSize: AppSize.textLarge.sp.sp,
                                      fontWeight: FontWeight.w600),
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
                                    AppNavigator.push(
                                        context,
                                        UserBlogList(
                                          userId: userEntity.userId!,
                                          userName: userEntity.userName!,
                                        ));
                                  },
                                  child: ListTile(
                                    leading: Text(
                                      'Blogs',
                                      style: TextStyle(
                                          fontSize: AppSize.textLarge.sp.sp,
                                          fontWeight: FontWeight.w600),
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
                      else
                        SizedBox.shrink()
                    ],
                  );
                }
                if (state is UserProfileLoading) {
                  return LoadingButton();
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

enum ItemUser { edit, delete, accountPrivacy }
