import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/button/loading.dart';
import 'package:Tracio/common/widget/error.dart';
import 'package:Tracio/common/widget/picture/circle_picture.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/profile/bloc/follow_cubit/follow_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowersScreen extends StatelessWidget {
  const FollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(),
      body: BlocBuilder<FollowCubit, FollowState>(
        builder: (context, state) {
          if (state is FollowLoading) {
            return LoadingButton();
          }
          if (state is FollowFailure) {
            return ErrorPage(
              text: 'Cannot load follower, pull to reload',
            );
          }
          if (state is FollowLoaded) {
            return ListView.builder(
              itemCount: state.follow.length,
              itemBuilder: (context, index) {
                final follower = state.follow[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Row(
                    children: [
                      CirclePicture(
                        imageUrl: follower.followerAvatarUrl ?? '',
                        imageSize: AppSize.imageSmall * .6.sp,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          follower.followerName ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      follower.status == 'accepted'
                          ? _messageButton()
                          : _followBackButton(),
                    ],
                  ),
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _followBackButton() {
    return ElevatedButton(
      onPressed: () {
        // Xử lý follow back
      },
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(fontSize: AppSize.textLarge),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      child: Text('Follow back'),
    );
  }

  Widget _messageButton() {
    return ElevatedButton(
      onPressed: () {
        // Mở chat
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
      ),
      child: Text('Message'),
    );
  }
}
