import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/groups/entities/group_route.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_state.dart';
import 'package:Tracio/presentation/groups/widgets/activity/calendar_box.dart';
import 'package:Tracio/presentation/groups/widgets/activity/group_activity_detail.dart';

class GroupActivityLoaded extends StatelessWidget {
  final GroupRouteEntity groupRoute;

  const GroupActivityLoaded({super.key, required this.groupRoute});

  @override
  Widget build(BuildContext context) {
    final time =
        TimeOfDay.fromDateTime(groupRoute.startDateTime).format(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: AppSize.apSectionMargin / 3),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          AppNavigator.push(
              context,
              BlocProvider.value(
                value: context.read<GroupCubit>()
                  ..getGroupRouteDetail(
                      groupRoute.groupRouteId,
                      context.read<GroupCubit>().state
                          as GetGroupDetailSuccess),
                child: GroupActivityDetail(
                  groupId: groupRoute.groupId,
                  groupRouteId: groupRoute.groupRouteId,
                ),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSize.apHorizontalPadding),
          child: Row(
            children: [
              // Calendar Box
              CalendarBox(startDateTime: groupRoute.startDateTime),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(groupRoute.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.directions_bike, size: 16),
                        const SizedBox(width: 4),
                        Text(time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
