import 'package:Tracio/common/bloc/generic_data_cubit.dart';
import 'package:Tracio/common/helper/is_dark_mode.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/common/widget/button/loading.dart';
import 'package:Tracio/domain/challenge/entities/challenge_reward.dart';
import 'package:Tracio/presentation/map/widgets/challenge_reward.dart';
import 'package:Tracio/presentation/profile/pages/follower.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/user/entities/user_profile_entity.dart';
import 'package:Tracio/presentation/profile/widgets/vital_tile.dart';

import '../../../domain/user/usecase/follow_user.dart';
import '../../../domain/user/usecase/unfollow_user..dart';
import '../../../service_locator.dart';
import '../../blog/widget/animated_button_follow.dart';

class Userinformation extends StatefulWidget {
  const Userinformation(
      {super.key, required this.user, required this.myProfile});
  final UserProfileEntity user;
  final bool myProfile;
  @override
  State<Userinformation> createState() => _UserinformationState();
}

class _UserinformationState extends State<Userinformation> {
  bool isAlreadyFollowed = false; // Lấy từ state/dữ liệu thực tế

  void _handleFollowLogic() async {
    await sl<FollowUserUseCase>().call(widget.user.userId!);
    setState(() {
      isAlreadyFollowed = true;
    });
    // setState(() { isAlreadyFollowed = true; }); // Ví dụ cập nhật UI ngay lập tức (tùy logic)
  }

  void _handleUnFollowLogic() async {
    await sl<UnFollowUserUseCase>().call(widget.user.userId!);
    setState(() {
      isAlreadyFollowed = false;
    });
  }

  @override
  void initState() {
    isAlreadyFollowed = widget.user.followStatus == 'Following';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.apVerticalPadding * .2.h),
      width: double.infinity,
      // height: 400.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 255, 255, 255)),
      child: Column(
        children: [
          SizedBox(height: 12.h),

          // Avatar
          CirclePicture(
              imageUrl: widget.user.profilePicture!,
              imageSize: AppSize.imageSmall.sp),
          // CircleAvatar(
          //   radius: 50,
          //   backgroundColor: Colors.grey[300],
          //   child: const Icon(Icons.person, size: 60),
          // ),
          const SizedBox(height: 12),

          // Name & Email
          Text(
            widget.user.userName!,
            style: TextStyle(
                fontSize: AppSize.textHeading, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            widget.user.email!,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          SizedBox(height: 10.h),
          Text(
            widget.user.bio!,
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.myProfile)
                AnimatedFollowButton(
                  alwaysVisible: isAlreadyFollowed,
                  initiallyFollowed: isAlreadyFollowed,
                  onUnfollow: _handleUnFollowLogic,
                  initialFillColor: Colors.transparent,
                  onFollow: _handleFollowLogic,
                  initialTextColor:
                      !context.isDarkMode ? Colors.black87 : Colors.white,
                  width: 160.w,
                  height: 30.h,
                )
              // else if (isAlreadyFollowed)
              //   const Text(
              //       "Followed") // Hoặc ButtonDesign với trạng thái "Unfollow"
            ],
          ),
          SizedBox(height: 10.h),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 40),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text.rich(TextSpan(
          //         text: 'Gender: ',
          //         style: TextStyle(
          //             fontWeight: FontWeight.bold, fontSize: AppSize.textLarge),
          //         children: [
          //           TextSpan(
          //               text: widget.user.gender,
          //               style: TextStyle(
          //                   fontWeight: FontWeight.normal,
          //                   fontSize: AppSize.textLarge))
          //         ],
          //       )),
          //       Text.rich(TextSpan(
          //         text: 'BirthDate: ',
          //         style: TextStyle(
          //             fontWeight: FontWeight.bold, fontSize: AppSize.textLarge),
          //         children: [
          //           TextSpan(
          //               text: widget.user.birthDate ?? '24/04/2003',
          //               style: TextStyle(fontWeight: FontWeight.normal))
          //         ],
          //       )),
          //     ],
          //   ),
          // ),
          const SizedBox(height: 8),
          widget.myProfile
              ? SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: InkWell(
                    onTap: () => AppNavigator.push(context, FollowersScreen()),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text.rich(TextSpan(
                          text: 'Follower: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSize.textLarge),
                          children: [
                            TextSpan(
                                text: widget.user.followers.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: AppSize.textLarge))
                          ],
                        )),
                        Text.rich(TextSpan(
                          text: 'Following: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSize.textLarge),
                          children: [
                            TextSpan(
                                text: widget.user.followings.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: AppSize.textLarge))
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
          const SizedBox(height: 24),
          _buildRewardsList(),

          // Average Vitals Label + Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Text(
                'Achievements',
                style: TextStyle(
                    fontSize: AppSize.textHeading, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Vital Items
          VitalTile(
            icon: Icons.directions_bike_outlined,
            title: 'Total Distance',
            value: widget.user.formattedDistance,
          ),
          VitalTile(
            icon: Icons.timer_outlined,
            title: 'Total Duration',
            value: widget.user.formattedDuration,
          ),
          VitalTile(
            icon: Icons.route_outlined,
            title: 'Total Route',
            value: widget.user.totalRoute.toString(),
          ),
          VitalTile(
            icon: Icons.photo_size_select_actual_outlined,
            title: 'Total Blog',
            value: widget.user.totalBlog.toString(),
          ),
          VitalTile(
            icon: Icons.local_fire_department_outlined,
            title: 'Day Streak',
            value: widget.user.totalBlog.toString(),
          ),
          VitalTile(
            icon: Icons.photo_size_select_actual_outlined,
            title: 'Total Blog',
            value: widget.user.totalBlog.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsList() {
    if (widget.user.rewards?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    final rewards = widget.user.rewards!;
    final itemCount =
        rewards.length > 4 ? 5 : rewards.length; // 4 rewards + 1 nút nếu > 4

    return Center(
      child: SizedBox(
        height: 120.h,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index == 4 && rewards.length > 4) {
              // Item cuối là nút mũi tên
              return GestureDetector(
                onTap: () {
                  // Điều hướng đến màn hình hiển thị tất cả rewards
                },
                child: Container(
                  width: 60.w,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        size: AppSize.iconLarge.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                      Text('More')
                    ],
                  ),
                ),
              );
            }
            // Các item reward
            return rewardItem(rewards[index]);
          },
        ),
      ),
    );
  }

  Widget rewardItem(ChallengeRewardEntity reward) {
    return Container(
      padding: EdgeInsets.only(right: 16),
      height: 100.h,
      width: 100.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: CirclePicture(
                imageUrl: reward.imageUrl!, imageSize: AppSize.iconMedium.sp),
            // Image.network(
            //   imageUrl,
            //   width: 30,
            //   height: 30,
            //   fit: BoxFit.cover,
            // ),
          ),
          SizedBox(height: 8),
          // Title below the image
          Text(
            reward.name!, // Dynamic title
            style: TextStyle(
                fontSize: AppSize.textMedium * 0.8.sp,
                fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
