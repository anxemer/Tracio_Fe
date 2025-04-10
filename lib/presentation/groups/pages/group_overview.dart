import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/core/constants/membership_enum.dart';
import 'package:tracio_fe/data/groups/models/response/get_participant_list_rep.dart';
import 'package:tracio_fe/domain/groups/entities/group.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_state.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GroupOverview extends StatefulWidget {
  final int groupId;
  const GroupOverview({super.key, required this.groupId});

  @override
  State<GroupOverview> createState() => _GroupOverviewState();
}

class _GroupOverviewState extends State<GroupOverview> {
  Future<void> _onRefresh() async {
    final groupId = widget.groupId;
    await context.read<GroupCubit>().getGroupDetail(groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Group Overview'),
      ),
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state is GroupLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetGroupDetailSuccess) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (_, __) => const SizedBox.shrink(),
                itemBuilder: (context, index) {
                  if (index == 0) return _buildHeader(state.group);
                  if (index == 1) {
                    return _buildMembersSection(
                        state.cyclists, state.group.participantCount);
                  }
                  return _buildActionsSection(
                      state.group.groupId, state.group.membership);
                },
              ),
            );
          } else if (state is GroupFailure) {
            return Center(child: Text('❌ Error: ${state.errorMessage}'));
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildHeader(Group group) {
    return Container(
      padding: const EdgeInsets.all(AppSize.apHorizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(AppSize.apHorizontalPadding),
          topLeft: Radius.circular(AppSize.apHorizontalPadding),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Name
          Text(
            group.groupName,
            style: TextStyle(
              fontSize: AppSize.textHeading.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_outline, size: 18),
                  const SizedBox(width: 4),
                  Text(
                      '${group.participantCount} Member${group.participantCount > 1 ? 's' : ''}',
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                      group.isPublic
                          ? Icons.public_outlined
                          : Icons.lock_outline,
                      size: 18),
                  const SizedBox(width: 4),
                  Text(group.isPublic ? 'Public' : 'Private',
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 4),
                  Text('${group.district}, ${group.city}',
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSize.apHorizontalPadding),
          if (group.description != null && group.description!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About this group',
                  style: TextStyle(
                    fontSize: AppSize.textLarge.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  group.description!,
                  style: TextStyle(color: Colors.black54, fontSize: 14.sp),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMembersSection(List<Cyclist> adminList, int totalMembers) {
    return Container(
      padding: const EdgeInsets.only(
          bottom: AppSize.apHorizontalPadding,
          left: AppSize.apHorizontalPadding,
          right: AppSize.apHorizontalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Text(
                'Members',
                style: TextStyle(
                  fontSize: AppSize.textLarge.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                '$totalMembers members',
                style: TextStyle(
                    fontSize: AppSize.textSmall.sp, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // List of cyclists
          ...adminList.map((cyclist) => _buildCyclistItem(cyclist)),

          const SizedBox(height: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // action here
              },
              child: Ink(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'See all $totalMembers members',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: AppSize.textSmall.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: AppSize.iconSmall / 2.w,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCyclistItem(Cyclist cyclist) {
    return Container(
        padding:
            EdgeInsets.symmetric(vertical: AppSize.apHorizontalPadding / 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: cyclist.participant.profilePicture,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cyclist.participant.userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: AppSize.textSmall.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "ADMIN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppSize.textSmall * 0.7.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
                child: Text(
                  "Follow",
                  style: TextStyle(fontSize: AppSize.textSmall.sp),
                ))
          ],
        ));
  }

  Widget _buildActionsSection(int groupId, MembershipEnum membership) {
    return Container(
      padding: const EdgeInsets.only(
          bottom: AppSize.apHorizontalPadding,
          left: AppSize.apHorizontalPadding,
          right: AppSize.apHorizontalPadding),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Actions',
            style: TextStyle(
                fontSize: AppSize.textLarge.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: AppSize.apHorizontalPadding.h),
          if (membership == MembershipEnum.member ||
              membership == MembershipEnum.admin)
            BlocConsumer<GroupCubit, GroupState>(
              listener: (context, state) {
                if (state is GetGroupDetailSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You have left the group'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                } else if (state is GroupFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                final isLoading = state is GroupLoading;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<GroupCubit>().leaveGroup(groupId);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Leave Group",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              },
            ),
          SizedBox(height: AppSize.apHorizontalPadding / 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Report Group",
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    );
  }
}
