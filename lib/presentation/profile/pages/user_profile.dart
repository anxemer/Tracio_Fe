import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/data/blog/models/request/get_blog_req.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:tracio_fe/presentation/profile/bloc/user_profile_cubit.dart';
import 'package:tracio_fe/presentation/profile/bloc/user_profile_state.dart';
import 'package:tracio_fe/presentation/profile/pages/edit_profile.dart';
import 'package:tracio_fe/presentation/profile/widgets/UserInformation.dart';
import 'package:tracio_fe/presentation/profile/widgets/user_blog_list.dart';

import '../../../domain/user/entities/user_profile_entity.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, this.userId});
  final int? userId;

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
    var isDark = context.isDarkMode;
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
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: BasicAppbar(
            height: 100.h,
            hideBack: false,
            title: Text(
              'Profile',
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.textExtraLarge.sp),
            ),
            action: Row(
              children: [
                PopupMenuButton<ItemUser>(
                  initialValue: selectedItem,
                  onSelected: (ItemUser item) {
                    setState(() {
                      selectedItem = item;
                    });
                    if (item == ItemUser.edit) {
                      // Chuyển sang trang Edit
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(user: userEntity)),
                      );
                    } else if (item == ItemUser.delete) {}
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
            )),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocBuilder<UserProfileCubit, UserProfileState>(
                  builder: (context, state) {
                    if (state is UserProfileLoaded) {
                      userEntity = state.userProfileEntity;
                      return Userinformation(
                        user: state.userProfileEntity,
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
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
                          'routes',
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
                            final blogCubit = context.read<GetBlogCubit>()
                              ..getBlog(GetBlogReq(
                                  userId: widget.userId.toString(),
                                  pageSize: 10));

                            AppNavigator.push(
                                context,
                                BlocProvider.value(
                                    value: blogCubit,
                                    child: UserBlogList(
                                      userId: widget.userId!,
                                      userName: userEntity.userName!,
                                    )));
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum ItemUser { edit, delete, accountPrivacy }
