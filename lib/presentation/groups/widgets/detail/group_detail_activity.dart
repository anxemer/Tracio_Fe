import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/presentation/groups/cubit/form_group_activity_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';
import 'package:tracio_fe/presentation/groups/pages/create_group_activity.dart';
import 'package:tracio_fe/presentation/groups/widgets/detail/empty_group_activity.dart';
import 'package:tracio_fe/presentation/groups/widgets/detail/group_activity_loaded.dart';

class GroupDetailActivity extends StatefulWidget {
  const GroupDetailActivity({super.key});

  @override
  State<GroupDetailActivity> createState() => _GroupDetailActivityState();
}

class _GroupDetailActivityState extends State<GroupDetailActivity> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, state) {
        if (state is GetGroupDetailSuccess) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.groupRoutes.isNotEmpty
                        ? "Upcoming Activities"
                        : "No upcoming activities",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AppNavigator.push(
                          context,
                          BlocProvider(
                            create: (context) => FormGroupActivityCubit(),
                            child: CreateGroupActivity(
                                groupId: state.group.groupId),
                          ));
                    },
                    child: Text(
                      "Create an activity",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.apHorizontalPadding / 2),
              if (state.groupRoutes.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: state.groupRoutes.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final activity = state.groupRoutes[index];
                    return GroupActivityLoaded(
                      groupRouteId: activity.groupRouteId,
                      title: activity.title,
                      dateTime: activity.startDateTime,
                      tag: "Beginner-Friendly",
                      participantCount: activity.participants.length,
                      participantAvatarUrl: activity.creator.profilePicture,
                    );
                  },
                ),
              if (state.groupRoutes.isEmpty) EmptyGroupActivity()
            ],
          );
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
