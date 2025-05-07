import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';
import 'package:Tracio/presentation/groups/widgets/detail_information_challenge.dart';
import 'package:Tracio/presentation/groups/widgets/leader_boar.dart';
import 'package:Tracio/presentation/map/widgets/challenge_reward.dart';

class ChallengeProgressScreen extends StatelessWidget {
  final ChallengeEntity challenge;

  const ChallengeProgressScreen({
    super.key,
    required this.challenge,
  });

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: AppSize.textLarge, color: Colors.grey.shade700),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: AppSize.textLarge,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int? currentValue = (challenge.progress != null)
        ? (challenge.progress! * challenge.goalValue!).round()
        : null;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            expandedHeight: 180.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz, color: AppColors.primary),
                onPressed: () {
                  // TODO: Hiển thị menu tùy chọn
                  print('More options tapped');
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: challenge.challengeThumbnail,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
            ),
          ),
          // --- Phần nội dung chính ---
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    challenge.title!,
                    style: TextStyle(
                      fontSize: AppSize.textHeading.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),

                  Text(
                    challenge.timeLeftDisplay,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: AppSize.textMedium.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Run ${challenge.goalValue} ${challenge.unit}',
                    style: TextStyle(
                      fontSize: AppSize.textMedium.sp,
                      color: Colors.grey.shade800,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: ' $currentValue',
                              style: TextStyle(
                                fontSize: AppSize.textLarge.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' / ${challenge.goalValue} ${challenge.unit}',
                              style: TextStyle(
                                fontSize: AppSize.textLarge.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Opacity(
                          opacity: 0.15,
                          child: CirclePicture(
                              imageUrl: challenge.challengeThumbnail,
                              imageSize: AppSize.iconMedium.sp)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: LinearProgressIndicator(
                      value: challenge.progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.secondBackground),
                    ),
                  ),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Place',
                        style: TextStyle(
                            fontSize: AppSize.textLarge,
                            color: Colors.grey.shade700),
                      ),
                      Text(
                        '${challenge.challengeRank}/${challenge.totalParticipants}',
                        style: TextStyle(
                            fontSize: AppSize.textLarge,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  InkWell(
                    onTap: () {
                      AppNavigator.push(
                          context,
                          LeaderboardScreen(
                              goalValue: challenge.goalValue!,
                              challengeId: challenge.challengeId!));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'View leaderboard',
                            style: TextStyle(
                              fontSize: AppSize.textHeading.sp,
                              color: AppColors.primary, // Màu giống theme
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              color: AppColors.primary,
                              size: AppSize.iconMedium),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),

                  Text(
                    'Challenge details',
                    style: TextStyle(
                      fontSize: AppSize.textHeading,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 35),

                  Text(
                    challenge.description!,
                    style: TextStyle(
                      fontSize: AppSize.textMedium,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 35),

                  DetailInformationChallenge(
                    participants: challenge.totalParticipants.toString(),
                    totalGoal: challenge.goalValue.toString(),
                    startDate: challenge.startDateFormatted,
                    endate: challenge.endDateFormatted,
                    unit: challenge.unit,
                  ),
                  // const SizedBox(height: 12),
                  // Text(
                  //   challenge.longDescription,
                  //   style: TextStyle(
                  //     fontSize: 15,
                  //     color: Colors.black87,
                  //     height: 1.5,
                  //   ),
                  // ),
                  const SizedBox(height: 40),
                  Text(
                    'Unlock Rewards',
                    style: TextStyle(
                      fontSize: AppSize.textHeading,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return ChallengeReward(
                    reward: challenge.challengeRewardMappings[index],
                  );
                },
                childCount: challenge.challengeRewardMappings.length,
              ),
            ),
          ),
        ],
      ),
      // Không có bottomNavigationBar ở màn hình này
    );
  }
}
