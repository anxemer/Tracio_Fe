import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/domain/groups/entities/group_route.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';

class GroupActivityFeed extends StatefulWidget {
  final int groupId;

  const GroupActivityFeed({super.key, required this.groupId});

  @override
  State<GroupActivityFeed> createState() => _GroupActivityFeedState();
}

class _GroupActivityFeedState extends State<GroupActivityFeed> {
  Future<void> _onRefresh() async {
    context.read<GroupCubit>().getGroupDetail(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Group Activity Feed"),
        ),
        body: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, state) {
            if (state is GroupLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetGroupDetailSuccess) {
              return RefreshIndicator(
                onRefresh: () async {
                  _onRefresh();
                },
                child: _buildActivityList(state.groupRoutes.groupList,
                    isPrivate: !state.group.isPublic),
              );
            }

            return const Center(child: Text('No data available'));
          },
        ));
  }

  Widget _buildActivityList(List<GroupRouteEntity> groupRoutes,
      {bool isPrivate = false}) {
    if (groupRoutes.isEmpty && !isPrivate) {
      return ListView(
        physics:
            const AlwaysScrollableScrollPhysics(), // allow pull even when empty
        children: const [
          SizedBox(height: 150),
          Center(child: Text('No activities yet.')),
        ],
      );
    }

    if (isPrivate) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 150),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: const Text(
                'You are not authorized to view activities of this private group.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      itemCount: groupRoutes.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final route = groupRoutes[index];

        return Card(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Route Info
                Text(route.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(route.description),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(route.formattedDate),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text(route.formattedTime),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.place, size: 16),
                    const SizedBox(width: 4),
                    Expanded(child: Text(route.addressMeeting)),
                  ],
                ),
                const Divider(height: 24),

                /// Participants Header
                Text("Participants (${route.participants.length})",
                    style: const TextStyle(fontWeight: FontWeight.w600)),

                /// Participants List
                ...route.participants.map((p) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(p.cyclistAvatarUrl),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.cyclistName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(
                                    "Joined: ${p.formattedDate} ${p.formattedTime}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          if (p.isOrganizer)
                            const Chip(
                              label: Text("Organizer"),
                              visualDensity: VisualDensity.compact,
                              labelStyle: TextStyle(fontSize: 12),
                            )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
