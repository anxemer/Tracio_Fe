import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';

class GroupActivityFeed extends StatefulWidget {
  final int groupId;
  const GroupActivityFeed({super.key, required this.groupId});

  @override
  State<GroupActivityFeed> createState() => _GroupActivityFeedState();
}

class _GroupActivityFeedState extends State<GroupActivityFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Activity Feed'),
      ),
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<GroupCubit>().getGroupDetail(widget.groupId);
            },
            child: Center(
              child: Text('Group Activity Feed Content'),
            ),
          );
        },
      ),
    );
  }
}
