import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:shimmer/shimmer.dart';
import 'package:Tracio/presentation/groups/widgets/detail/empty_group_activity.dart';

class GroupDetailSkeleton extends StatelessWidget {
  const GroupDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(AppSize.apHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Avatar, name
            _buildSkeleton(100.w, 100),

            const SizedBox(
              height: AppSize.apHorizontalPadding,
            ),
            _buildSkeleton(120.w, 28),

            const SizedBox(
              height: AppSize.apHorizontalPadding / 2,
            ),
            _buildSkeleton(200.w, 20),
            const SizedBox(
              height: AppSize.apHorizontalPadding,
            ),
            Wrap(
              spacing: AppSize.apHorizontalPadding / 2,
              runSpacing: AppSize.apHorizontalPadding / 2,
              children: [
                SizedBox(
                  width: 120.w,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people_outline,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 8.0),
                      _buildSkeleton(80.w, 20),
                    ],
                  ),
                ),
                SizedBox(
                  width: 120.w,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 8.0),
                      _buildSkeleton(80.w, 20),
                    ],
                  ),
                ),
                const SizedBox(width: AppSize.apHorizontalPadding),
                SizedBox(
                  width: 120.w,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.pedal_bike_outlined,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 8.0),
                      _buildSkeleton(80.w, 20),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSize.apHorizontalPadding),

            _buildSkeleton(MediaQuery.of(context).size.width, 30.h),
            const SizedBox(height: AppSize.apSectionMargin),
            const Divider(),
            const SizedBox(height: AppSize.apHorizontalPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipOval(
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Edit')
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipOval(
                        child: IconButton(
                          icon: Icon(Icons.visibility),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Overview')
                  ],
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipOval(
                        child: IconButton(
                          icon: Icon(Icons.access_time),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Activities')
                  ],
                ),
              ],
            ),

            const SizedBox(height: AppSize.apHorizontalPadding),
            const Divider(),

            const SizedBox(height: AppSize.apSectionMargin),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "No upcoming activities",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "Create an activity",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSize.apHorizontalPadding / 2),

            EmptyGroupActivity()
          ],
        ),
      ),
    );
  }

  Shimmer _buildSkeleton(double width, double height,
      {double borderRadius = 12}) {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius:
                BorderRadius.circular(borderRadius), // Rounded corners
          ),
        ));
  }
}
