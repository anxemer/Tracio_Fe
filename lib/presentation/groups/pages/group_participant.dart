import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/domain/groups/entities/group_route.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';

class GroupParticipant extends StatefulWidget {
  final int groupId;
  const GroupParticipant({super.key, required this.groupId});

  @override
  State<GroupParticipant> createState() => _GroupParticipantState();
}

class _GroupParticipantState extends State<GroupParticipant> {
  Future<void> _onRefresh() async {
    context.read<GroupCubit>().getGroupDetail(widget.groupId);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Group Participants'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Members'),
              Tab(text: 'Owners'),
            ],
          ),
        ),
        body: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, state) {
            if (state is GroupLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (state is GetGroupDetailSuccess) {
              return TabBarView(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.apHorizontalPadding,
                          vertical: 12.0,
                        ),
                        color: Colors.grey.shade300,
                        child: Text(
                          "Members",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.textMedium.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: _buildParticipantListWithLoadMore(
                            participants: state.participants.participants
                                .where((p) => !p.isOrganizer)
                                .toList(),
                            hasNextPage: state.participants.hasNextPage,
                            onLoadMore: () {
                              context.read<GroupCubit>().getGroupDetail(
                                    widget.groupId,
                                    participantRowsPerPage:
                                        state.participants.totalCount,
                                  );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.apHorizontalPadding,
                          vertical: 12.0,
                        ),
                        color: Colors.grey.shade300,
                        child: Text(
                          "Owner",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                            fontSize: AppSize.textMedium.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: _buildParticipantListWithLoadMore(
                            participants: state.participants.participants
                                .where((p) => p.isOrganizer)
                                .toList(),
                            hasNextPage: state.participants.hasNextPage,
                            onLoadMore: () {
                              context.read<GroupCubit>().getGroupDetail(
                                    widget.groupId,
                                    participantRowsPerPage:
                                        state.participants.totalCount,
                                  );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
            return Center(child: Text("Something wrong"));
          },
        ),
      ),
    );
  }

  Widget _buildParticipantListWithLoadMore({
    required List<Participant> participants,
    required bool hasNextPage,
    required VoidCallback onLoadMore,
  }) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: participants.length + (hasNextPage ? 1 : 0),
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        if (index < participants.length) {
          final user = participants[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  CachedNetworkImageProvider(user.cyclistAvatarUrl),
            ),
            title: Text(
              user.cyclistName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              "Joined at: ${user.formattedDate} ${user.formattedTime}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppColors.secondBackground),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Followed ${user.cyclistName}")),
                  );
                },
                child: Text(
                  "Follow",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ),
          );
        } else {
          // Load More row
          return Center(
            child: InkWell(
              onTap: onLoadMore,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  "Load more...",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
