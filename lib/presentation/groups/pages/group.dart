import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/chat/page/chat.dart';
import 'package:tracio_fe/presentation/groups/widgets/active_challenge_tab.dart';
import 'package:tracio_fe/presentation/groups/widgets/challenge_tab.dart';
import 'package:tracio_fe/presentation/groups/widgets/group_tab.dart';
import 'package:tracio_fe/presentation/notifications/page/notifications.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: const TabBar(
                labelColor: Colors.black,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: "Active"),
                  Tab(text: "Challenges"),
                  Tab(text: "Groups"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [ActiveChallengeTab(), ChallengeTab(), GroupTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return BasicAppbar(
      height: AppSize.appBarHeight.h,
      hideBack: true,
      title: Text(
        'Groups',
        style: TextStyle(
          color: context.isDarkMode ? Colors.white : Colors.black87,
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
            AppNavigator.push(context, ChatPage());
          },
          icon: Icon(
            Icons.mail,
            color: AppColors.primary,
            size: AppSize.iconMedium.w,
          ),
          tooltip: "Message",
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
            Icons.search,
            color: AppColors.primary,
            size: AppSize.iconMedium.w,
          ),
          tooltip: "Search",
        ),
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
      ],
    );
  }
}
