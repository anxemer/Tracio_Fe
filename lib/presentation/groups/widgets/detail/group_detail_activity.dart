import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/core/constants/membership_enum.dart';
import 'package:Tracio/presentation/groups/cubit/form_group_activity_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_state.dart';
import 'package:Tracio/presentation/groups/pages/create_group_activity.dart';
import 'package:Tracio/presentation/groups/widgets/detail/empty_group_activity.dart';
import 'package:Tracio/presentation/groups/widgets/activity/group_activity_loaded.dart';

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
          final maxTime = DateTime.now().add(Duration(minutes: 60));
          final minTime = DateTime.now().subtract(Duration(minutes: 30));
          final upcomingRoutes = state.groupRoutes.groupRouteList
              .where((route) => route.startDateTime.isAfter(minTime))
              .where((route) => route.startDateTime.isBefore(maxTime))
              .where((route) => route.groupStatus == "NotStarted")
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!state.groupRouteDetailsError)
                    Text(
                      upcomingRoutes.isNotEmpty
                          ? "Upcoming Activities"
                          : "No upcoming activities",
                      style: TextStyle(
                        color: upcomingRoutes.isNotEmpty
                            ? AppColors.primary
                            : Colors.black54,
                      ),
                    ),
                  if (state.group.membership == MembershipEnum.member ||
                      state.group.membership == MembershipEnum.admin)
                    GestureDetector(
                      onTap: () {
                        AppNavigator.push(
                          context,
                          BlocProvider(
                            create: (_) => FormGroupActivityCubit(),
                            child: CreateGroupActivity(
                              groupId: state.group.groupId,
                            ),
                          ),
                        );
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
              if (upcomingRoutes.isNotEmpty)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: upcomingRoutes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final activity = upcomingRoutes[index];
                    return GroupActivityLoaded(groupRoute: activity);
                  },
                ),
              if (upcomingRoutes.isEmpty && !state.groupRouteDetailsError)
                const EmptyGroupActivity(),
              if (state.groupRouteDetailsError)
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Center(
                    child: Text(
                      "This group is private. Please join in to see more.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
