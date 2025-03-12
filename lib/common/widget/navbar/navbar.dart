import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';

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
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(width: .8, color: Colors.grey.shade200),
              )),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.w),
          child: GNav(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              duration: Duration(milliseconds: 300),
              tabMargin: EdgeInsets.symmetric(horizontal: 5),
              haptic: true,
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              iconSize: 28,
              curve: Curves.easeIn,
              color: Colors.grey.shade600,
              hoverColor: AppColors.background.withAlpha(80),
              rippleColor: Colors.transparent,
              activeColor: AppColors.primary,
              gap: 8,
              tabActiveBorder:
                  Border.all(color: AppColors.background, width: 1),
              tabBorderRadius: 20,
              tabBorder: Border.all(color: Colors.grey.shade300, width: 1),
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
                  icon: Icons.shop_outlined,
                  text: 'Services',
                ),
                GButton(
                  icon: Icons.more_vert_sharp,
                  text: 'More',
                )
              ]),
        ),
      ),
    );
  }
}
