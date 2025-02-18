import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/blog/header_information.dart';
import 'package:tracio_fe/core/configs/theme/assets/app_images.dart';
import 'package:tracio_fe/presentation/blog/bloc/get_blog_cubit.dart';
import 'package:tracio_fe/presentation/blog/widget/new_feed.dart';

import '../../../common/helper/navigator/app_navigator.dart';
import '../../../common/widget/appbar/app_bar.dart';
import '../../../common/widget/button/floating_button.dart';
import '../../../domain/auth/usecases/logout.dart';
import '../../../service_locator.dart';
import '../../auth/pages/login.dart';

class BlogPage extends StatelessWidget {
  BlogPage({super.key, required this.controller});
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetBlogCubit()..getBlog(),
      child: Scaffold(
        appBar: BasicAppbar(
            height: 100.h,
            hideBack: false,
            title: Text(
              'Home',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 40.sp),
            ),
            action: Row(
              children: [
                FloatingButton(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  onPressed: () {},
                  action: Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.black,
                  ),
                ),
                FloatingButton(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  onPressed: () {},
                  action: Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.black,
                  ),
                ),
                FloatingButton(
                  elevation: 1,
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    await sl<LogoutUseCase>().call();

                    AppNavigator.pushReplacement(context, LoginPage());
                  },
                  action: Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            )),
        body: CustomScrollView(controller: controller, slivers: [
          SliverToBoxAdapter(
            child: _createBlog(),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20.h,
            ),
          ),
          NewFeeds()
        ]),
      ),
    );
  }

  Widget _createBlog() {
    return Container(
        width: double.infinity,
        height: 100.h,
        child: HeaderInformation(
            title: Text('Bạn đang nghĩ gì?'),
            imageUrl: Image.asset(AppImages.man),
            trailling: Icon(Icons.image_outlined)));
  }
}
