import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/groups/widgets/active_challenge_item.dart';
import 'package:tracio_fe/presentation/groups/widgets/recommend_challenge_item.dart'; // For CircularProgressIndicator

class ChallengeTab extends StatefulWidget {
  const ChallengeTab({super.key});

  @override
  State<ChallengeTab> createState() => _ChallengeTabState();
}

class _ChallengeTabState extends State<ChallengeTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          // Horizontal Scrollable Filter Buttons
          Container(
            padding: const EdgeInsets.fromLTRB(AppSize.apHorizontalPadding,
                AppSize.apVerticalPadding, 0, AppSize.apVerticalPadding),
            height: 50.h,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterButton("Distance"),
                _buildFilterButton("Moving Time"),
                _buildFilterButton("Duration"),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.apHorizontalPadding,
                vertical: AppSize.apVerticalPadding),
            color: Colors.white,
            child: Column(
              spacing: AppSize.apSectionPadding,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Active Challenges",
                  style: TextStyle(
                    fontSize: AppSize.textMedium.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 80.h,
                  width: double.infinity,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildActiveChallengeItem(),
                      _buildActiveChallengeItem(),
                      _buildActiveChallengeItem(),
                      _buildActiveChallengeItem(),
                      _buildActiveChallengeItem(),
                      _buildActiveChallengeItem(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSize.apVerticalPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.apHorizontalPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: AppSize.apHorizontalPadding / 2,
                  children: [
                    Icon(
                      Icons.local_attraction_rounded,
                      size: AppSize.iconMedium,
                    ),
                    Text("Recommended For You",
                        style: TextStyle(
                            fontSize: AppSize.textSmall.sp,
                            fontWeight: FontWeight.w600)),
                  ],
                ),

                // List of recommended groups
                SizedBox(height: 16),
              ],
            ),
          ),
          Wrap(
            spacing: AppSize.apHorizontalPadding / 4,
            runSpacing: AppSize.apHorizontalPadding / 4,
            children: List.generate(
              12,
              (index) {
                return RecommendChallengeItem(
                  groupImageUrl: 'https://www.eurobasket.com/logos/torr.png',
                  groupName: 'Group tên dài quá dài',
                  address: 'Hà nội, Hồ Chí Minh, Bình Định, Bình Dương',
                  memberCount: 12126,
                );
              },
            ),
          ),

          const SizedBox(
            height: AppSize.apVerticalPadding,
          ),

          const SizedBox(
            height: AppSize.apVerticalPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSize.apHorizontalPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: AppSize.apHorizontalPadding / 2,
                  children: [
                    Icon(
                      Icons.local_attraction_rounded,
                      size: AppSize.iconMedium,
                    ),
                    Text("Joined Challenges",
                        style: TextStyle(
                            fontSize: AppSize.textSmall.sp,
                            fontWeight: FontWeight.w600)),
                  ],
                ),

                // List of recommended groups
                SizedBox(height: 16),
              ],
            ),
          ),
          Wrap(
            spacing: AppSize.apHorizontalPadding / 4,
            runSpacing: AppSize.apHorizontalPadding / 4,
            children: List.generate(
              3,
              (index) {
                return RecommendChallengeItem(
                  groupImageUrl: 'https://www.eurobasket.com/logos/torr.png',
                  groupName: 'Group tên dài quá dài',
                  address: 'Hà nội, Hồ Chí Minh, Bình Định, Bình Dương',
                  memberCount: 12126,
                );
              },
            ),
          ),

          const SizedBox(
            height: AppSize.apVerticalPadding,
          ),
        ],
      ),
    );
  }

  // Helper method to build the filter buttons
  Widget _buildFilterButton(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: TextButton(
        onPressed: () {
          // Handle filter button click
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(width: 0.8, color: Colors.black45)),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: AppSize.textSmall * 0.8.sp, color: Colors.black87),
        ),
      ),
    );
  }

  // Helper method to build each active challenge item
  Widget _buildActiveChallengeItem() {
    return Container(
      width: 60.w,
      margin: const EdgeInsets.only(right: 16),
      child: ActiveChallengeItem(
        title: "Run 10k in a week",
        imageUrl: 'https://www.eurobasket.com/logos/torr.png',
        progression: 0.75,
      ),
    );
  }
}
