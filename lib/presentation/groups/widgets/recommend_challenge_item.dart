import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/is_dark_mode.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/common/widget/picture/circle_picture.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/challenge/entities/challenge_entity.dart';
import 'package:tracio_fe/presentation/groups/cubit/challenge_cubit.dart';
import 'package:tracio_fe/presentation/groups/widgets/challenge_progress.dart';

import 'challenge_detail.dart';

class RecommendChallengeItem extends StatelessWidget {
  final ChallengeEntity challenge;
  const RecommendChallengeItem({
    super.key,
    required this.challenge,
  });

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;
    return BlocListener<ChallengeCubit, ChallengeState>(
      listenWhen: (previous, current) {
        return current is JoinChallengeLoaded;
      },
      listener: (context, state) {
        if (state is JoinChallengeLoaded &&
            state.challengeId == challenge.challengeId) {
          AppNavigator.push(
            context,
            ChallengeProgressScreen(challengeId: challenge.challengeId!),
          );
        }
      },
      child: InkWell(
        onTap: () async {
          AppNavigator.push(
            context,
            ChallengeDetailScreen(
              challengeId: challenge.challengeId!,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(AppSize.apHorizontalPadding * 0.7),
          // width: MediaQuery.of(context).size.width * 0.4,
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 2.w - 10,
            maxWidth: MediaQuery.of(context).size.width / 2.w - 10,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkGrey : Colors.white,
            borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Image
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8),
              //   child: Image.network(
              //     groupImageUrl,
              //     width: AppSize.imageSmall.w,
              //     height: AppSize.imageSmall.w,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              CirclePicture(
                  imageUrl: challenge.challengeThumbnail,
                  imageSize: AppSize.imageSmall),
              const SizedBox(height: 8),
              // Group Info
              Text(
                challenge.title!,
                maxLines: 2,
                style: TextStyle(
                    fontSize: AppSize.textTitle * 0.5.sp,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 4),
              Text(
                'Run ${challenge.goalValue} ${challenge.unit}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: AppSize.textSmall.sp,
                    color: Colors.grey.shade700),
              ),
              SizedBox(height: 4),
              Text(
                challenge.timeLeftDisplay,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: AppSize.textSmall.sp,
                    color: Colors.grey.shade700),
              ),
              // SizedBox(height: 4),
              // Text(
              //   '$memberCount members',
              //   style: TextStyle(
              //       fontSize: AppSize.textSmall.sp, color: Colors.grey.shade700),
              // ),
              SizedBox(height: 12),
              // Join Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    context
                        .read<ChallengeCubit>()
                        .joinChallenge(challenge.challengeId!);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSize.apVerticalPadding / 2),
                    backgroundColor: AppColors.secondBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSize.borderRadiusMedium),
                    ),
                  ),
                  child: Text(
                    'Join',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: AppSize.textSmall.sp,
                        fontWeight: FontWeight.w600),
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
