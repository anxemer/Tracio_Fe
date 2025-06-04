import 'package:Tracio/presentation/groups/cubit/challenge_cubit.dart';
import 'package:Tracio/presentation/groups/pages/search_group_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/core/services/signalR/implement/group_route_hub_service.dart';
import 'package:Tracio/presentation/chat/pages/conversation.dart';
import 'package:Tracio/presentation/groups/cubit/invitation_bloc.dart';
import 'package:Tracio/presentation/groups/widgets/challenge_tab.dart';
import 'package:Tracio/presentation/groups/widgets/group_tab.dart';
import 'package:Tracio/presentation/notifications/page/notifications.dart';
import 'package:Tracio/service_locator.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, this.initialIndex = 1});
  final int initialIndex;
  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with SingleTickerProviderStateMixin {
  final groupRouteHub = sl<GroupRouteHubService>();
  late TabController _tabController;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => InvitationBloc(),
        ),
        BlocProvider(
          create: (context) => ChallengeCubit(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: "Challenges"),
                  Tab(text: "Groups"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  ChallengeTab(),
                  GroupTab(),
                ],
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
        _currentIndex == 0 ? 'Challenges' : 'Groups',
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
            AppNavigator.push(context, ConversationScreen());
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchGroupUser()));
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
