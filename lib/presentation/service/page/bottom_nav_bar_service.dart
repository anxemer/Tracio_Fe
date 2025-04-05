import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/service/page/my_booking.dart';
import 'package:tracio_fe/presentation/service/page/plan_service.dart';
import 'package:tracio_fe/presentation/service/page/service.dart';
import 'package:tracio_fe/presentation/service/widget/plan_service_icon.dart';

class BottomNavBarService extends StatefulWidget {
  const BottomNavBarService({super.key});

  @override
  State<BottomNavBarService> createState() => _BottomNavBarServiceState();
}

class _BottomNavBarServiceState extends State<BottomNavBarService> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    ServicePage(),
    PlanServicePage(),
    MyBookingPage(),
    // ServicePage(),
    // MorePage(),
  ];
  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: 60,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                duration: Duration(milliseconds: 300),
                tabMargin: EdgeInsets.symmetric(horizontal: 5),
                haptic: true,
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
                onTabChange: _onTabChanged, // Update selected tab index
                tabs: [
                  GButton(
                    icon: Icons.home_outlined,
                    text: 'Service',
                  ),
                  GButton(
                    icon: Icons.explore_outlined,
                    text: 'Plan',
                  ),
                  GButton(
                    icon: Icons.directions_bike,
                    text: "My Booking",
                  ),
                  // GButton(
                  //   icon: Icons.shop_outlined,
                  //   text: 'Services',
                  // ),
                  // GButton(
                  //   icon: Icons.more_vert_outlined,
                  //   text: 'More',
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
