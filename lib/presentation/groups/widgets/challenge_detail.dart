import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/groups/cubit/challenge_cubit.dart';
import 'package:tracio_fe/presentation/groups/widgets/detail_information_challenge.dart';
import 'package:tracio_fe/presentation/map/widgets/challenge_reward.dart';

class ChallengeDetailScreen extends StatelessWidget {
  const ChallengeDetailScreen({
    super.key,
    required this.challengeId,
  });
  final int challengeId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChallengeCubit()..getChallengeDetail(challengeId),
      child: BlocBuilder<ChallengeCubit, ChallengeState>(
        builder: (context, state) {
          if (state is ChallengeDetailLoaded) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    expandedHeight: 180.0,
                    backgroundColor: AppColors.secondBackground,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.more_horiz, color: Colors.white),
                        onPressed: () {
                          print('More options tapped');
                        },
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: CachedNetworkImage(
                        imageUrl: state.challenge.challengeThumbnail,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 20.0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          Text(
                            state.challenge.timeLeftDisplay,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: AppSize.textMedium,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.challenge.title!,
                            style: TextStyle(
                              fontSize: AppSize.textHeading,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'run ${state.challenge.goalValue} ${state.challenge.unit}',
                            style: TextStyle(
                              fontSize: AppSize.textLarge,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            state.challenge.description!,
                            style: TextStyle(
                              fontSize: AppSize.textLarge,
                              color: Colors.grey.shade700,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          DetailInformationChallenge(
                              participants:
                                  state.challenge.totalParticipants.toString(),
                              unit: state.challenge.unit,
                              totalGoal: state.challenge.goalValue.toString(),
                              startDate: state.challenge.startDateFormatted,
                              endate: state.challenge.endDateFormatted),
                          const SizedBox(height: 16),
                          const Text(
                            'Unlock rewards',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return ChallengeReward(
                            reward:
                                state.challenge.challengeRewardMappings[index],
                          );
                        },
                        childCount:
                            state.challenge.challengeRewardMappings.length,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: const SizedBox(height: 100), // Khoảng trống cuối
                  ),
                ],
              ),

              // --- Nút hành động ở dưới cùng ---
              bottomNavigationBar: Container(
                // Container để tạo hiệu ứng đổ bóng nhẹ và padding
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Nền trắng để nổi bật nút
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, -2), // Shadow hướng lên trên
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Xử lý logic khi nhấn nút (Join/View Progress/...)
                    print('Action button tapped!');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary, // Màu nút
                    foregroundColor: Colors.white, // Màu chữ trên nút
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          AppSize.borderRadiusMedium), // Bo tròn mạnh
                    ),
                    textStyle: TextStyle(
                        fontSize: AppSize.textLarge,
                        fontWeight: FontWeight.bold),
                    minimumSize: const Size(
                        double.infinity, 50), // Nút chiếm toàn bộ chiều rộng
                  ),
                  child: Text('Join challenge'),
                ),
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
}
