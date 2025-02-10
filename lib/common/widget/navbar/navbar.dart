import 'package:flutter/material.dart';
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.w),
        child: GNav(
            tabMargin: EdgeInsets.symmetric(horizontal: 5),
            haptic: true,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            iconSize: 20,
            curve: Curves.easeIn,
            color: Colors.grey.withValues(alpha: .5),
            hoverColor: Colors.lightBlueAccent,
            activeColor: Colors.lightBlueAccent,
            gap: 8,
            tabActiveBorder: Border.all(color: Colors.lightBlueAccent),
            tabBorderRadius: 70,
            tabBorder:
                Border.all(color: Colors.black.withValues(alpha: .5), width: 1),
            tabs: [
              GButton(
                icon: Icons.person,
                text: 'You',
              ),
              GButton(
                icon: Icons.more_horiz,
                text: 'More',
              ),
              GButton(
                icon: Icons.home,
                text: 'Challenges',
              ),
              GButton(
                icon: Icons.home,
                text: 'Activity',
              ),
              GButton(
                icon: Icons.home,
                text: 'Activity',
              )
            ]),
      ),
    );
  }
}
