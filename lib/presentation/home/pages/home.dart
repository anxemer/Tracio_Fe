import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/user/entities/daily_activity_entity.dart';
import 'package:Tracio/domain/user/usecase/get_daily_activity.dart';
import 'package:Tracio/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/bloc/generic_data_cubit.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/blog/bloc/comment/get_comment_cubit.dart';
import 'package:Tracio/presentation/blog/pages/blog.dart';
import 'package:Tracio/presentation/chat/bloc/bloc/conversation_bloc.dart';
import 'package:Tracio/presentation/chat/pages/conversation.dart';
import 'package:Tracio/presentation/notifications/page/notifications.dart';

import '../../../data/blog/models/request/get_blog_req.dart';
import '../../auth/bloc/authCubit/auth_cubit.dart';
import '../../blog/bloc/create_blog_cubit.dart';
import '../../blog/bloc/get_blog_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GenericDataCubit()),
        BlocProvider(
            create: (context) => GetBlogCubit()..getBlog(GetBlogReq())),
        BlocProvider(create: (context) => CreateBlogCubit()),
        BlocProvider(create: (context) => GetCommentCubit()),
        BlocProvider(
            create: (context) => GenericDataCubit()
              ..getData<DailyActivityEntity>(sl<GetDailyActivityUseCase>(),
                  params: NoParams())),
      ],
      child: SafeArea(
        bottom: true,
        child: Scaffold(
          appBar: _buildAppBar(),
          body: BlogPage(
              // scrollController: _scrollController,
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
            color: AppColors.primary,
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
            AppNavigator.push(
                context,
                BlocProvider.value(
                  value: context.read<ConversationBloc>()
                    ..add(GetConversations()),
                  child: ConversationScreen(),
                ));
          },
          icon: Icon(
            Icons.mail,
            color: AppColors.primary,
            size: AppSize.iconMedium.w,
          ),
          tooltip: "Message",
        ),
        // IconButton(
        //   padding: EdgeInsets.zero,
        //   highlightColor: Colors.grey.shade600,
        //   splashColor: Colors.white.withAlpha(30),
        //   hoverColor: Colors.white.withAlpha(10),
        //   onPressed: () async {
        //     context.read<AuthCubit>().logout();
        //     AppNavigator.pushReplacement(context, LoginPage());
        //   },
        //   icon: Icon(
        //     context.isDarkMode
        //         ? Icons.dark_mode_rounded
        //         : Icons.light_mode_rounded,
        //     // color: Colors.white,
        //     size: AppSize.iconMedium.w,
        //   ),
        //   tooltip: "logout",
        // )
      ],
    );
  }
}
