import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tracio_fe/common/helper/navigator/app_navigator.dart';
import 'package:tracio_fe/core/configs/theme/app_colors.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/core/constants/membership_enum.dart';
import 'package:tracio_fe/data/groups/models/request/get_group_list_req.dart';
import 'package:tracio_fe/domain/groups/entities/group.dart';
import 'package:tracio_fe/presentation/groups/cubit/group_cubit.dart';
import 'package:tracio_fe/presentation/groups/cubit/invitation_bloc.dart';
import 'package:tracio_fe/presentation/groups/pages/group_detail.dart';

class RecommendGroupItem extends StatefulWidget {
  final Group group;
  final MembershipEnum membership;

  const RecommendGroupItem({
    super.key,
    required this.group,
    required this.membership,
  });

  @override
  State<RecommendGroupItem> createState() => _RecommendGroupItemState();
}

class _RecommendGroupItemState extends State<RecommendGroupItem> {
  late MembershipEnum _membership;

  @override
  void initState() {
    super.initState();
    _membership = widget.membership;
  }

  void _handleJoinRequest(BuildContext context) {
    setState(() {
      _membership = MembershipEnum.requested;
    });

    final bloc = context.read<InvitationBloc>();
    bloc.add(RequestJoin(widget.group.groupId));
  }

  void _handleRefresh() {
    GetGroupListReq request =
        GetGroupListReq(pageNumber: 1, pageSize: 10, getMyGroups: true);
    context.read<GroupCubit>().getGroupList(request);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge),
      onTap: () async {
        AppNavigator.push(
            context,
            BlocProvider.value(
              value: BlocProvider.of<InvitationBloc>(context),
              child: GroupDetailScreen(
                groupId: widget.group.groupId,
              ),
            ));
      },
      child: Ink(
        padding: const EdgeInsets.all(AppSize.apHorizontalPadding * 0.7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.borderRadiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.group.groupThumbnail,
                width: AppSize.imageSmall.w,
                height: AppSize.imageSmall.w,
                fit: BoxFit.cover,
                errorBuilder: (context, url, error) => Container(
                  width: AppSize.imageSmall.w,
                  height: AppSize.imageSmall.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.error,
                      color: AppColors.background,
                    ),
                  ),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Group Info
            Text(
              widget.group.groupName,
              maxLines: 2,
              style: TextStyle(
                  fontSize: AppSize.textTitle * 0.5.sp,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              "${widget.group.district}, ${widget.group.city}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: AppSize.textSmall.sp, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.group.participantCount} members',
              style: TextStyle(
                  fontSize: AppSize.textSmall.sp, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),

            RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                text: 'Created by ',
                style: TextStyle(
                  fontSize: AppSize.textSmall.sp,
                  color: Colors.grey.shade700,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: widget.group.creatorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSize.textSmall.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            // Join Button
            BlocListener<InvitationBloc, InvitationState>(
              listenWhen: (prev, curr) {
                return curr.status != prev.status &&
                    curr.lastAction == InvitationActionType.requestJoin &&
                    curr.groupId == widget.group.groupId;
              },
              listener: (context, state) {
                if (state.status == InvitationStatus.success) {
                  _handleRefresh();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Join request sent!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else if (state.status == InvitationStatus.failure) {
                  setState(() {
                    _membership = MembershipEnum.none;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.failure?.message ?? 'Request failed'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: buildJoinButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJoinButton() {
    switch (_membership) {
      case MembershipEnum.none:
      case MembershipEnum.left:
      case MembershipEnum.kicked:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _handleJoinRequest(context);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: AppSize.apVerticalPadding / 2,
              ),
              backgroundColor: AppColors.secondBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.borderRadiusMedium),
              ),
            ),
            child: Text(
              'Join',
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.textSmall.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

      case MembershipEnum.pending:
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'You have been invited to this group. Please confirm.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        );

      case MembershipEnum.requested:
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Your join request is pending admin approval.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        );

      case MembershipEnum.member:
      case MembershipEnum.admin:
        return const SizedBox.shrink();
    }
  }
}
