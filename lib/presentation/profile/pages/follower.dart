import 'dart:async';

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

import '../../../common/helper/navigator/app_navigator.dart';
import '../../chat/bloc/bloc/conversation_bloc.dart';
import '../../chat/pages/conversation.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen(
      {super.key, required this.userId, required this.isFollower});
  final int userId;
  final bool isFollower;
  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  late ScrollController _scrollController;
  Timer? _scrollDebounce;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  void _scrollListener() {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    double scrollPercentage = 0.7;

    if (currentScroll > (maxScroll * scrollPercentage)) {
      if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();

      _scrollDebounce = Timer(const Duration(milliseconds: 500), () {
        final followState = context.read<FollowCubit>().state;
        if (followState is FollowLoaded &&
            followState.pagination.hasNextPage!) {
          if (widget.isFollower) {
            context.read<FollowCubit>().getMoreFollower(widget.userId);
          } else {
            context.read<FollowCubit>().getMoreFollowing(widget.userId);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (widget.isFollower) {
          context.read<FollowCubit>().getMoreFollower(widget.userId);
        } else {
          context.read<FollowCubit>().getMoreFollowing(widget.userId);
        }
      },
      child: Scaffold(
        appBar: BasicAppbar(),
        body: BlocBuilder<FollowCubit, FollowState>(
          builder: (context, state) {
            if (state is FollowLoading) {
              return LoadingButton();
            }
            if (state is FollowFailure) {
              return ErrorPage(
                text: 'This account is private',
              );
            }
            if (state is FollowLoaded) {
              return ListView.builder(
                controller: _scrollController,
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
                            ? _messageButton(follower.followerId!)
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

  Widget _messageButton(int userId) {
    return ElevatedButton(
      onPressed: () {
        AppNavigator.push(
            context,
            BlocProvider.value(
              value: context.read<ConversationBloc>()
                ..add(CreateConversation(userId: userId)),
              child: ConversationScreen(),
            ));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade800,
        foregroundColor: Colors.white,
      ),
      child: Text('Message'),
    );
  }
}
