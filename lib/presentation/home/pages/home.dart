import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/bloc/generic_data_cubit.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/blog/bloc/comment/get_comment_cubit.dart';
import 'package:tracio_fe/presentation/blog/pages/blog.dart';
import 'package:tracio_fe/presentation/chat/page/chat.dart';
import 'package:tracio_fe/presentation/notifications/page/notifications.dart';

import '../../../data/blog/models/request/get_blog_req.dart';
import '../../auth/bloc/authCubit/auth_cubit.dart';
import '../../auth/pages/login.dart';
import '../../blog/bloc/create_blog_cubit.dart';
import '../../blog/bloc/get_blog_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GenericDataCubit()),
        BlocProvider(
            create: (context) => GetBlogCubit()..getBlog(GetBlogReq())),
        BlocProvider(create: (context) => CreateBlogCubit()),
        BlocProvider(create: (context) => GetCommentCubit()),
        BlocProvider(create: (context) => AuthCubit()..checkUser())
      ],
      child: SafeArea(
        bottom: true,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: BlogPage(
            scrollController: _scrollController,
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return BasicAppbar(
      height: AppSize.appBarHeight.h,
      hideBack: true,
      title: Text(
        'Home',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: AppSize.textHeading * 0.9.sp,
        ),
      ),
      action: _buildActionIcons(),
    );
  }

  Widget _buildActionIcons() {
    return Row(
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          highlightColor: Colors.grey.shade600,
          splashColor: Colors.white.withAlpha(30),
          hoverColor: Colors.white.withAlpha(10),
          onPressed: () {
            AppNavigator.push(context, NotificationsPage());
          },
          icon: Icon(
            Icons.notifications,
            color: Colors.white,
            size: AppSize.iconMedium.w,
          ),
          tooltip: "Notifications",
        ),
        IconButton(
          padding: EdgeInsets.zero,
          highlightColor: Colors.grey.shade600,
          splashColor: Colors.white.withAlpha(30),
          hoverColor: Colors.white.withAlpha(10),
          onPressed: () {
            AppNavigator.push(context, ChatPage());
          },
          icon: Icon(
            Icons.mail,
            color: Colors.white,
            size: AppSize.iconMedium.w,
          ),
          tooltip: "Message",
        ),
        IconButton(
          padding: EdgeInsets.zero,
          highlightColor: Colors.grey.shade600,
          splashColor: Colors.white.withAlpha(30),
          hoverColor: Colors.white.withAlpha(10),
          onPressed: () async {
            context.read<AuthCubit>().logout();
            AppNavigator.pushReplacement(context, LoginPage());
          },
          icon: Icon(
            Icons.output_sharp,
            color: Colors.white,
            size: AppSize.iconMedium.w,
          ),
          tooltip: "logout",
        )
      ],
    );
  }
}
