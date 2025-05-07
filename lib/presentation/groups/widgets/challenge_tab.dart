import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';
import 'package:Tracio/presentation/groups/cubit/challenge_cubit.dart';
import 'package:Tracio/presentation/groups/widgets/active_challenge_item.dart';
import 'package:Tracio/presentation/groups/widgets/challenge_progress.dart';
import 'package:Tracio/presentation/groups/widgets/create_challenge.dart';
import 'package:Tracio/presentation/groups/widgets/recommend_challenge_item.dart';

import '../../../common/widget/button/button.dart';
import '../../../core/configs/theme/app_colors.dart'; // For CircularProgressIndicator

class ChallengeTab extends StatefulWidget {
  const ChallengeTab({super.key});

  @override
  State<ChallengeTab> createState() => _ChallengeTabState();
}

class _ChallengeTabState extends State<ChallengeTab> {
  @override
  void initState() {
    if (context.read<ChallengeCubit>().state is! ChallengeLoaded) {
      context.read<ChallengeCubit>().getChallengeOverview();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = context.isDarkMode;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ChallengeCubit>().getChallengeOverview();
      },
      child: BlocBuilder<ChallengeCubit, ChallengeState>(
        builder: (context, state) {
          if (state is ChallengeLoaded) {
            List<ChallengeEntity> activeChallenge =
                state.challengeOverview.activeChallenges;
            List<ChallengeEntity> recommendChallenge =
                state.challengeOverview.suggestedChallenges;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Horizontal Scrollable Filter Buttons
                  Container(
                    padding: const EdgeInsets.fromLTRB(
                        AppSize.apHorizontalPadding,
                        AppSize.apVerticalPadding,
                        0,
                        AppSize.apVerticalPadding),
                    height: 50.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Colors.grey.shade300))),
                    // child: ListView(
                    //   scrollDirection: Axis.horizontal,
                    //   children: [
                    //     _buildFilterButton("Distance"),
                    //     _buildFilterButton("Moving Time"),
                    //     _buildFilterButton("Duration"),
                    //   ],
                    // ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSize.apHorizontalPadding),
                    child: ButtonDesign(
                      width: double.infinity,
                      height: 30.h,
                      ontap: () {
                        AppNavigator.push(context, CreateChallengeScreen());
                      },
                      fillColor: Colors.transparent,
                      borderColor: isDark ? Colors.white : Colors.black,
                      fontSize: AppSize.textMedium,
                      text: 'Create Challenge',
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  activeChallenge.isEmpty
                      ? SizedBox.shrink()
                      : Container(
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
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: activeChallenge.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          AppNavigator.push(
                                              context,
                                              ChallengeProgressScreen(
                                                challengeId:
                                                    activeChallenge[index]
                                                        .challengeId!,
                                              ));
                                        },
                                        child: _buildActiveChallengeItem(
                                            activeChallenge[index].title!,
                                            activeChallenge[index]
                                                .challengeThumbnail,
                                            activeChallenge[index].progress!),
                                      );
                                    },
                                  )),
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
                    children: recommendChallenge.map((challenge) {
                      return RecommendChallengeItem(
                        challenge: challenge,
                      );
                    }).toList(),
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
                              Icons.done_outline_rounded,
                              size: AppSize.iconMedium,
                            ),
                            Text("Previous Challenges",
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
                  state.challengeOverview.previousChallenges.isNotEmpty
                      ? Wrap(
                          spacing: AppSize.apHorizontalPadding / 4,
                          runSpacing: AppSize.apHorizontalPadding / 4,
                          children: List.generate(
                            state.challengeOverview.previousChallenges.length,
                            (index) {
                              return RecommendChallengeItem(
                                challenge: state.challengeOverview
                                    .previousChallenges[index],
                              );
                            },
                          ),
                        )
                      : SizedBox.shrink(),

                  const SizedBox(
                    height: AppSize.apVerticalPadding,
                  ),
                ],
              ),
            );
          }
          if (state is ChallengeLoading) {
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: AppColors.secondBackground,
                size: AppSize.iconExtraLarge,
              ),
            );
          }
          if (state is ChallengeFailure) {
            return Container();
          }
          return Container();
        },
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
  Widget _buildActiveChallengeItem(
      String title, String imageUrl, double progress) {
    return Container(
      width: 60.w,
      margin: const EdgeInsets.only(right: 16),
      child: ActiveChallengeItem(
        title: title,
        imageUrl: imageUrl,
        progression: progress,
      ),
    );
  }
}
