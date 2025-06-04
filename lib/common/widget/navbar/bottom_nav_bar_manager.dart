import 'package:Tracio/presentation/map/bloc/tracking/bloc/tracking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/core/services/signalR/implement/chat_hub_service.dart';
import 'package:Tracio/presentation/exploration/page/exploration.dart';
import 'package:Tracio/presentation/groups/pages/group.dart';
import 'package:Tracio/presentation/home/pages/home.dart';
import 'package:Tracio/presentation/map/pages/cycling.dart';
import 'package:Tracio/presentation/more/page/more.dart';
import 'package:Tracio/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  DateTime? _lastBackPressed;

  final List<Widget> _screens = [
    HomePage(),
    ExplorationPage(),
    CyclingPage(),
    GroupPage(),
    MorePage(),
  ];
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

    Future.microtask(() async {
      await sl<ChatHubService>().connect();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        if (_selectedIndex != 0) {
          setSelectedIndex(0);
          setNavVisible(true);
          return;
        }
        // Double tap to exit logic
        final now = DateTime.now();
        if (_lastBackPressed == null ||
            now.difference(_lastBackPressed!) > Duration(seconds: 2)) {
          _lastBackPressed = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tap back again to exit')),
          );
          return;
        }
        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard Changes?'),
            content: const Text(
                'You have unsaved changes. Are you sure you want to leave?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Leave'),
              ),
            ],
          ),
        );
        if (shouldLeave == true && mounted) {
          context.read<TrackingBloc>().add(EndTracking());
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
        child: Scaffold(
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
                    color:
                        context.isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
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
                    color: context.isDarkMode
                        ? Colors.white
                        : Colors.grey.shade600,
                    hoverColor: AppColors.background.withAlpha(80),
                    rippleColor: Colors.transparent,
                    activeColor: AppColors.primary,
                    gap: 8,
                    tabActiveBorder:
                        Border.all(color: AppColors.background, width: 1),
                    tabBorderRadius: 20,
                    tabBorder:
                        Border.all(color: Colors.grey.shade300, width: 1),
                    onTabChange: _onTabChanged,
                    selectedIndex: _selectedIndex,
                    tabs: [
                      GButton(
                        icon: Icons.home_outlined,
                        text: 'Home',
                      ),
                      GButton(
                        icon: Icons.explore_outlined,
                        text: 'Explore',
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
        ),
      ),
    );
  }
}
