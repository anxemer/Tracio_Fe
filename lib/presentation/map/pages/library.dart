import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/widget/appbar/app_bar.dart';
import 'package:tracio_fe/presentation/map/pages/cycling.dart';
import 'package:tracio_fe/presentation/map/pages/route_planner.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: TabBarView(
          children: [
            buildFeatureSection(
              title: "Cycling Mode",
              description:
                  "Track your rides and enjoy guided cycling with real-time metrics and insights.",
              buttonText: "Start Riding",
              onPressed: () => _navigateTo(context, CyclingPage()),
            ),
            buildFeatureSection(
              title: "Plan Your Own Routes",
              description:
                  "Use the Mobile Route Planner to plan your routes, in advance or on-the-fly, with turn-by-turn directions, waypoints, estimated ride times, and custom cues.",
              buttonText: "Start Planning",
              onPressed: () => _navigateTo(context, RoutePlanner()),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the top AppBar with tabs
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(200.h),
      child: Column(
        children: [
          BasicAppbar(
            height: 100.h,
            hideBack: false,
            title: Text(
              'Library',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 40.sp,
              ),
            ),
          ),
          const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Cycling"),
              Tab(text: "Route Planner"),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds a reusable feature section with title, description, and button
  Widget buildFeatureSection({
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 8.h),
          Text(description, style: TextStyle(fontSize: 28.sp)),
          SizedBox(height: 16.h),
          buildActionButton(buttonText, onPressed),
          SizedBox(height: 16.h),
          
        ],
      ),
    );
  }

  /// Builds a reusable button with consistent styling
  Widget buildActionButton(String text, VoidCallback onPressed) {
    return Center(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child:
              Text(text, style: TextStyle(color: Colors.black87, fontSize: 16)),
        ),
      ),
    );
  }

  /// Handles navigation to a new page
  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
