import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BasicNavbar extends StatefulWidget {
  const BasicNavbar({super.key});

  @override
  State<BasicNavbar> createState() => _BasicNavbarState();
}

class _BasicNavbarState extends State<BasicNavbar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: .8, color: Colors.grey.shade200),
            )),
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.w),
        child: GNav(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            duration: Duration(milliseconds: 300),
            tabMargin: EdgeInsets.symmetric(horizontal: 5),
            haptic: true,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            iconSize: 36.h,
            curve: Curves.easeIn,
            color: Colors.grey.shade600,
            hoverColor: AppColors.background.withAlpha(80),
            rippleColor: Colors.transparent,
            activeColor: AppColors.primary,
            gap: 8,
            tabActiveBorder: Border.all(color: AppColors.background, width: 1),
            tabBorderRadius: 20,
            tabBorder: Border.all(color: Colors.grey.shade300, width: 1),
            onTabChange: (index) {
              print(index);
            },
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
                icon: Icons.shop_outlined,
                text: 'Services',
              ),
              GButton(
                icon: Icons.more_vert_sharp,
                text: 'More',
              )
            ]),
      ),
    );
  }
}
