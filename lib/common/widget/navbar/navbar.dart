import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BasicNavbar extends StatelessWidget {
  BasicNavbar({super.key, required this.isNavbarVisible});

  final bool isNavbarVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      height: isNavbarVisible ? 60 : 0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.w),
          child: GNav(
              duration: Duration(milliseconds: 100),
              tabMargin: EdgeInsets.symmetric(horizontal: 5),
              haptic: true,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              iconSize: 20,
              curve: Curves.easeIn,
              color: Colors.grey.withValues(alpha: .5),
              hoverColor: Colors.transparent,
              rippleColor: Colors.transparent,
              activeColor: Colors.lightBlueAccent,
              gap: 8,
              tabActiveBorder: Border.all(color: Colors.lightBlueAccent),
              tabBorderRadius: 70,
              tabBorder: Border.all(
                  color: Colors.black.withValues(alpha: .5), width: 1),
              tabs: [
                GButton(
                  icon: Icons.person,
                ),
                GButton(
                  icon: Icons.more_horiz,
                ),
                GButton(
                  icon: Icons.home,
                ),
                GButton(
                  icon: Icons.home,
                ),
                GButton(
                  icon: Icons.home,
                )
              ]),
        ),
      ),
    );
  }
}
