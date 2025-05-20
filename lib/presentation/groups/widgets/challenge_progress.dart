import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/button/loading.dart';
import 'package:Tracio/common/widget/dialog_confirm.dart';
import 'package:Tracio/common/widget/error.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';
import 'package:Tracio/presentation/groups/widgets/detail_information_challenge.dart';
import 'package:Tracio/presentation/groups/widgets/leader_boar.dart';
import 'package:Tracio/presentation/map/widgets/challenge_reward.dart';

import '../cubit/challenge_cubit.dart';

class ChallengeProgressScreen extends StatefulWidget {
  const ChallengeProgressScreen({
    super.key,
    required this.challengeId,
  });
  final int challengeId;
  @override
  State<ChallengeProgressScreen> createState() =>
      _ChallengeProgressScreenState();
}

class _ChallengeProgressScreenState extends State<ChallengeProgressScreen> {
  @override
  void initState() {
    context.read<ChallengeCubit>().getChallengeDetail(widget.challengeId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChallengeCubit, ChallengeState>(
      listener: (context, state) {
        if (state is LeaveChallengeLoaded) {
          Navigator.pop(context);
          // AppNavigator.pushReplacement(
          //     context,
          //     BottomNavBarManager(
          //       selectedIndex: 3,
          //     ));
        }
      },
      builder: (context, state) {
        if (state is ChallengeDetailLoaded) {
          ChallengeEntity challenge = state.challenge;
          int? currentValue = (challenge.progress != null)
              ? (challenge.progress! * challenge.goalValue!).round()
              : null;
          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: [
              Positioned.fill(
                child: CustomScrollView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      pinned: true,
                      expandedHeight: 180.0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);

                            // AppNavigator.pushReplacement(
                            //     context,
                            //     BottomNavBarManager(
                            //       selectedIndex: 3,
                            //     ));
                          }),
                      actions: [
                        PopupMenuButton<int>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (int result) {
                            if (result == 0) {
                            } else if (result == 1) {
                              // handle delete
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<int>>[
                            PopupMenuItem<int>(
                              value: 0,
                              child: Row(
                                children: const [
                                  Icon(Icons.delete_outline_outlined,
                                      color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('Delete Challenge'),
                                ],
                              ),
                            ),
                          ],
                        )
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
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 4),
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
                            SizedBox(height: 10.h),

                            Text(
                              'Run ${challenge.goalValue} ${challenge.unit}',
                              style: TextStyle(
                                fontSize: AppSize.textMedium.sp,
                                color: Colors.grey.shade800,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 10.h),

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
                                    opacity: challenge.isCompleted! ? 1 : 0.15,
                                    child: CirclePicture(
                                        imageUrl: challenge.challengeThumbnail,
                                        imageSize: AppSize.iconMedium.sp)),
                              ],
                            ),
                            SizedBox(height: 10.h),

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
                            SizedBox(height: 10.h),

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
                            SizedBox(height: 10.h),

                            InkWell(
                              onTap: () {
                                AppNavigator.push(
                                    context,
                                    LeaderboardScreen(
                                        goalValue: challenge.goalValue!,
                                        challengeId: challenge.challengeId!));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'View leaderboard',
                                      style: TextStyle(
                                        fontSize: AppSize.textHeading.sp,
                                        color: AppColors
                                            .primary, // Màu giống theme
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
                            SizedBox(height: 10.h),

                            Text(
                              'Challenge details',
                              style: TextStyle(
                                fontSize: AppSize.textHeading,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 10.h),

                            Text(
                              challenge.description!,
                              style: TextStyle(
                                fontSize: AppSize.textMedium,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 10),

                            DetailInformationChallenge(
                              challengeId: challenge.challengeId!,
                              myChallenge: challenge.isCreator!,
                              isPublic: challenge.isPublic!,
                              isSystem: challenge.isSystem!,
                              create: challenge.creatorName,
                              participants:
                                  challenge.totalParticipants.toString(),
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
                            SizedBox(height: 10.h),

                            Text(
                              'Unlock Rewards',
                              style: TextStyle(
                                fontSize: AppSize.textHeading,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                          horizontal: AppSize.apHorizontalPadding),
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
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 80),
                    ),
                  ],
                ),
              ),
              if (challenge.isCreator!)
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppSize.apVerticalPadding,
                          horizontal: AppSize.apHorizontalPadding),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppSize.borderRadiusMedium),
                          ),
                          textStyle: TextStyle(
                              fontSize: AppSize.textLarge,
                              fontWeight: FontWeight.bold),
                          minimumSize: const Size(double.infinity,
                              50), // Nút chiếm toàn bộ chiều rộn
                        ),
                        child: Text('Invite Friends'),
                      ),
                    ))
              // else if (challenge.isCompleted!)
              //   Center(child: Text('Lỗi nè'))
              else if (!challenge.isCompleted!)
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: AppSize.apVerticalPadding,
                          horizontal: AppSize.apHorizontalPadding),
                      child: ElevatedButton(
                        onPressed: () {
                          DialogConfirm(
                                  btnLeft: () {
                                    Navigator.pop(context);
                                    context
                                        .read<ChallengeCubit>()
                                        .leaveChallenge(challenge.challengeId!);
                                  },
                                  btnRight: () {
                                    Navigator.pop(context);
                                  },
                                  notification:
                                      'Are you sure you want to leave?')
                              .showDialogConfirmation(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppSize.borderRadiusMedium),
                          ),
                          textStyle: TextStyle(
                              fontSize: AppSize.textLarge,
                              fontWeight: FontWeight.bold),
                          minimumSize: const Size(double.infinity,
                              50), // Nút chiếm toàn bộ chiều rộn
                        ),
                        child: Text('Leave challenge'),
                      ),
                    ))
            ]),
          );
        }
        if (state is ChallengeLoading) {
          return LoadingButton();
        }
        if (state is ChallengeFailure) {
          return ErrorPage();
        }
        return SizedBox.shrink();
      },
    );
  }
}
