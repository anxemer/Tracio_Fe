import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/service/page/my_booking.dart';
import 'package:Tracio/presentation/service/page/plan_service.dart';
import 'package:Tracio/presentation/service/page/service.dart';
import 'package:Tracio/presentation/service/page/tab_more.dart';
import 'package:Tracio/presentation/service/widget/plan_service_icon.dart';
import 'package:Tracio/presentation/shop_owner/page/dash_board.dart';

class BottomNavBarService extends StatefulWidget {
  const BottomNavBarService({super.key});

  @override
  State<BottomNavBarService> createState() => _BottomNavBarServiceState();
}

class _BottomNavBarServiceState extends State<BottomNavBarService>
    with SingleTickerProviderStateMixin {
  final iconList = [
    Icons.home_outlined,
    Icons.explore_outlined,
    Icons.directions_bike,
    Icons.more_vert_outlined,
  ];

  final labels = ['Service', 'Plan', 'My Booking', 'More'];

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ServicePage(),
    PlanServicePage(),
    MyBookingPage(),
    TabMorePage(),
  ];

  late AnimationController _animationController;

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
      if (_animationController.isDismissed) {
        return;
      }
      _animationController.forward(from: 0);
    });
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive
              ? AppColors.primary
              : (isDark ? Colors.white : Colors.grey.shade600);

          Widget iconWidget;

          if (index == 1) {
            iconWidget = PlanServiceIcon(
              isActive: isActive,
            );
          } else {
            iconWidget = Icon(
              iconList[index],
              size: AppSize.iconSmall.w,
              color: color,
            );
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              iconWidget,
              // SizedBox(height: 2),
              Text(
                labels[index],
                style: TextStyle(
                  color: color,
                  fontSize: AppSize.textSmall.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              )
            ],
          );
        },
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        activeIndex: _selectedIndex,
        splashColor: AppColors.primary.withOpacity(0.2),
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        gapLocation: GapLocation.none,
        leftCornerRadius: 24,
        rightCornerRadius: 24,
        elevation: 4,
        onTap: _onTabChanged,
      ),
    );
  }
}
