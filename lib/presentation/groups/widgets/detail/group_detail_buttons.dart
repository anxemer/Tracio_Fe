import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/membership_enum.dart';
import 'package:tracio_fe/presentation/groups/cubit/form_edit_group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';
import 'package:tracio_fe/presentation/groups/cubit/invitation_bloc.dart';
import 'package:tracio_fe/presentation/groups/pages/edit_group.dart';
import 'package:tracio_fe/presentation/groups/pages/group_activity_feed.dart';
import 'package:tracio_fe/presentation/groups/pages/group_overview.dart';

class GroupDetailButtons extends StatefulWidget {
  final MembershipEnum membership;
  const GroupDetailButtons({super.key, required this.membership});

  @override
  State<GroupDetailButtons> createState() => _GroupDetailButtonsState();
}

class _GroupDetailButtonsState extends State<GroupDetailButtons> {
  late MembershipEnum _membership;
  @override
  void initState() {
    _membership = widget.membership;
    super.initState();
  }

  void _handleJoinRequest(BuildContext context, int groupId) {
    setState(() {
      _membership = MembershipEnum.requested;
    });

    final bloc = context.read<InvitationBloc>();
    bloc.add(RequestJoin(groupId));
  }

  void _handleRefresh(int groupId) {
    context.read<GroupCubit>().getGroupDetail(groupId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(builder: (context, groupState) {
      if (groupState is GetGroupDetailSuccess) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (groupState.group.membership == MembershipEnum.admin)
              //EDIT GROUP BUTTON
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: ClipOval(
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          AppNavigator.push(
                              context,
                              BlocProvider(
                                create: (context) => FormEditGroupCubit(),
                                child: EditGroupScreen(
                                  group: groupState.group,
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Edit')
                ],
              ),

            //Join REQUEST BUTTON
            if (_membership != MembershipEnum.member)
              BlocListener<InvitationBloc, InvitationState>(
                listenWhen: (prev, curr) {
                  return curr.status != prev.status &&
                      curr.lastAction == InvitationActionType.requestJoin &&
                      curr.groupId == groupState.group.groupId;
                },
                listener: (context, state) {
                  if (state.status == InvitationStatus.success) {
                    _handleRefresh(groupState.group.groupId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Join request sent!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state.status == InvitationStatus.failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(state.failure?.message ?? 'Request failed'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(
                            alpha: _membership == MembershipEnum.requested
                                ? 0.5
                                : 0.85),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: ClipOval(
                        child: IconButton(
                          icon: Icon(
                            _membership == MembershipEnum.requested
                                ? Icons.check
                                : Icons.add,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _handleJoinRequest(
                                context, groupState.group.groupId);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                        _membership == MembershipEnum.requested
                            ? "Joined"
                            : 'Join',
                        style: TextStyle(
                          color: _membership == MembershipEnum.requested
                              ? Colors.black
                              : AppColors.primary,
                          fontWeight: _membership == MembershipEnum.requested
                              ? FontWeight.w500
                              : FontWeight.w700,
                        ))
                  ],
                ),
              ),

            //OVERVIEW GROUP BUTTON
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipOval(
                    child: IconButton(
                      icon: Icon(Icons.visibility),
                      onPressed: () {
                        AppNavigator.push(
                            context,
                            BlocProvider.value(
                              value: BlocProvider.of<InvitationBloc>(context),
                              child: BlocProvider.value(
                                value: BlocProvider.of<GroupCubit>(context),
                                child: GroupOverview(
                                  groupId: groupState.group.groupId,
                                ),
                              ),
                            ));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text('Overview')
              ],
            ),

            //ACTIVITY FEED BUTTON
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ClipOval(
                    child: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () {
                        AppNavigator.push(
                            context,
                            BlocProvider.value(
                              value: BlocProvider.of<GroupCubit>(context),
                              child: GroupActivityFeed(
                                groupId: groupState.group.groupId,
                              ),
                            ));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text('Activities')
              ],
            ),
          ],
        );
      } else {
        return SizedBox.shrink();
      }
    });
  }
}
