import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/blog/header_information.dart';
import 'package:tracio_fe/common/widget/button/basic_app_button.dart';
import 'package:tracio_fe/common/widget/button/button.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/presentation/auth/bloc/authCubit/auth_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/get_commnet_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/create_blog_cubit.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:tracio_fe/presentation/blog/pages/create_blog.dart';
import 'package:tracio_fe/presentation/blog/widget/new_feed.dart';
import 'package:tracio_fe/presentation/blog/widget/post_blog.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../common/widget/appbar/app_bar.dart';
import '../../../common/widget/button/floating_button.dart';
import '../../../domain/auth/usecases/logout.dart';
import '../../auth/pages/login.dart';
import '../bloc/get_blog_state.dart';

class BlogPage extends StatelessWidget {
  BlogPage({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetBlogCubit()..getBlog(),
        ),
        BlocProvider(
          create: (context) => CreateBlogCubit(),
        ),
      ],
      child: Scaffold(
        appBar: BasicAppbar(
            centralTitle: true,
            height: 100.h,
            hideBack: true,
            title: Text(
              'Home',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 40.sp),
            ),
            action: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Image.asset(
                    AppImages.noti,
                    width: 40.w,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Image.asset(
                    AppImages.messenger,
                    width: 40.w,
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  GestureDetector(
                    onTap: () async {
                      context.read<AuthCubit>().logout();
                      AppNavigator.pushReplacement(context, LoginPage());
                    },
                    child: Image.asset(
                      AppImages.search,
                      width: 40.w,
                    ),
                  ),
                  // ButtonDesign(
                  //     width: 30.w,
                  //     // height: 40.h,
                  //     ontap: () {},
                  //     icon: AppImages.noti,
                  //     fillColor: Colors.transparent,
                  //     borderColor: Colors.transparent)
                  // FloatingButton(
                  //   backgroundColor: Colors.transparent,
                  //   onPressed: () {},
                  //   action: Icon(
                  //     Icons.notifications_none_outlined,
                  //     color: Colors.black,
                  //     size: 40.sp,
                  //   ),
                  // ),

                  // FloatingButton(
                  //   backgroundColor: Colors.transparent,
                  //   onPressed: () {},
                  //   action: Icon(
                  //     Icons.chat_bubble_outline,
                  //     color: Colors.black,
                  //     size: 40.sp,
                  //   ),
                  // ),
                  // FloatingButton(
                  //   backgroundColor: Colors.transparent,
                  //   onPressed: () async {
                  //     context.read<AuthCubit>().logout();
                  //     AppNavigator.pushReplacement(context, LoginPage());
                  //   },
                  //   action: Icon(
                  //     Icons.search_outlined,
                  //     color: Colors.black,
                  //     size: 40.sp,
                  //   ),
                  // ),
                ],
              ),
            )),
        body: BlocBuilder<GetBlogCubit, GetBlogState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: AppColors.background,
              onRefresh: () async {
                context.read<GetBlogCubit>().getBlog();
              },
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  if (state is GetBlogLoading) ...[
                    SliverToBoxAdapter(
                      child: Center(
                          child: Column(
                        children: [
                          _createBlog(context),
                          CircularProgressIndicator(),
                        ],
                      )),
                    ),
                  ] else if (state is GetBlogLoaded) ...[
                    SliverToBoxAdapter(
                      child: _createBlog(context),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              PostBlog(blogEntity: state.listBlog[index]),
                          childCount: state.listBlog.length),
                    )
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _createBlog(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppNavigator.push(context, CreateBlogPage());
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
            width: double.infinity,
            height: 100.h,
            child: HeaderInformation(
                title: Text(
                  'An Xểm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Share your picture'),
                imageUrl: Image.asset(AppImages.man),
                trailling: Icon(
                  Icons.image_outlined,
                  size: 40.w,
                ))),
      ),
    );
  }
}
