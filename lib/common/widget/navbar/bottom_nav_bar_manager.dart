import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/core/services/signalR/implement/chat_hub_service.dart';
import 'package:tracio_fe/presentation/exploration/page/exploration.dart';
import 'package:tracio_fe/presentation/groups/pages/group.dart';
import 'package:tracio_fe/presentation/home/pages/home.dart';
import 'package:tracio_fe/presentation/map/pages/cycling.dart';
import 'package:tracio_fe/presentation/more/page/more.dart';
import 'package:tracio_fe/service_locator.dart';

class BottomNavBarManager extends StatefulWidget {
  final int? selectedIndex;
  final bool? isNavVisible;
  const BottomNavBarManager({super.key, this.selectedIndex, this.isNavVisible});

  @override
  State<BottomNavBarManager> createState() => BottomNavBarManagerState();
}

class BottomNavBarManagerState extends State<BottomNavBarManager> {
  int _selectedIndex = 0;

  final double _navHeight = 60;
  bool _isNavVisible = true;

  late List<Widget> _screens;
  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _isNavVisible = _selectedIndex != 2;
    });
  }

  void setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void setNavVisible(bool isVisible) {
    setState(() {
      _isNavVisible = isVisible;
    });
  }

  @override
  void initState() {
    _selectedIndex = widget.selectedIndex ?? 0;
    _isNavVisible = widget.isNavVisible ?? true;
    _screens = [
      HomePage(),
      ExplorationPage(),
      CyclingPage(),
      GroupPage(
        initialIndex: _selectedIndex == 3 ? 1 : 2,
      ),
      MorePage(),
    ];
    Future.microtask(() async {
      await sl<ChatHubService>().connect();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens.map((screen) {
                return Visibility(
                  visible: _screens.indexOf(screen) == _selectedIndex,
                  child: screen,
                );
              }).toList(),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: _isNavVisible ? _navHeight : 0,
            child: Container(
              decoration: BoxDecoration(
                color: context.isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                border: Border(
                  top: BorderSide(
                      width: .8,
                      color: context.isDarkMode
                          ? Colors.white
                          : Colors.grey.shade200),
                ),
              ),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(
                  horizontal: AppSize.apHorizontalPadding / 3.h,
                  vertical: AppSize.apVerticalPadding / 3.w),
              child: GNav(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                duration: Duration(milliseconds: 300),
                tabMargin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(
                    horizontal: AppSize.apHorizontalPadding / 2.w,
                    vertical: AppSize.apVerticalPadding / 2.h),
                iconSize: AppSize.iconSmall.w,
                curve: Curves.easeIn,
                color: context.isDarkMode ? Colors.white : Colors.grey.shade600,
                hoverColor: AppColors.background.withAlpha(80),
                rippleColor: Colors.transparent,
                activeColor: AppColors.primary,
                gap: 8,
                tabActiveBorder:
                    Border.all(color: AppColors.background, width: 1),
                tabBorderRadius: 20,
                tabBorder: Border.all(color: Colors.grey.shade300, width: 1),
                onTabChange: _onTabChanged,
                selectedIndex: _selectedIndex,
                tabs: [
                  GButton(
                    icon: Icons.home_outlined,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.explore_outlined,
                    text: 'Maps',
                  ),
                  GButton(
                    icon: Icons.directions_bike,
                    text: "Ride",
                  ),
                  GButton(
                    icon: Icons.group_outlined,
                    text: 'Groups',
                  ),
                  GButton(
                    icon: Icons.more_vert_outlined,
                    text: 'More',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
