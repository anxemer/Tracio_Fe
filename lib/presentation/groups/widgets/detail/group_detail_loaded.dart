import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/presentation/auth/bloc/authCubit/auth_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_state.dart';
import 'package:Tracio/presentation/groups/widgets/detail/group_detail_activity.dart';
import 'package:Tracio/presentation/groups/widgets/detail/group_detail_buttons.dart';

class GroupDetailLoaded extends StatefulWidget {
  const GroupDetailLoaded({
    super.key,
  });

  @override
  State<GroupDetailLoaded> createState() => _GroupDetailLoadedState();
}

class _GroupDetailLoadedState extends State<GroupDetailLoaded> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
      builder: (context, groupState) {
        if (groupState is GetGroupDetailSuccess) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(AppSize.apHorizontalPadding),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100.w,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: groupState.group.groupThumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(
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
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.apHorizontalPadding / 2,
                  ),
                  //Group name

                  Text(
                    groupState.group.groupName,
                    style: TextStyle(
                        fontSize: AppSize.textHeading.sp,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: AppSize.apHorizontalPadding / 2,
                  ),
                  //Address
                  Text(
                    "Group location: ${groupState.group.district}, ${groupState.group.city}",
                    style: TextStyle(
                        fontSize: AppSize.textMedium.sp, color: Colors.black54),
                  ),
                  const SizedBox(
                    height: AppSize.apHorizontalPadding,
                  ),
                  Wrap(
                    spacing: AppSize.apHorizontalPadding / 2,
                    runSpacing: AppSize.apHorizontalPadding / 2,
                    children: [
                      SizedBox(
                        width: 120.w,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.people_outline,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              "${groupState.group.participantCount} members",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 120.w,
                        child: Row(
                          children: [
                            Icon(
                              groupState.group.isPublic
                                  ? Icons.lock_open_outlined
                                  : Icons.lock_outline,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 8.0),
                            Text(groupState.group.isPublic
                                ? "Public"
                                : "Private"),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSize.apHorizontalPadding),
                      SizedBox(
                        width: 120.w,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.pedal_bike_outlined,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 8.0),
                            Text(groupState.group.totalGroupRoutes > 0
                                ? "${groupState.group.totalGroupRoutes} activities"
                                : "No activities"),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSize.apHorizontalPadding),
                  //Description
                  if (groupState.group.description != null &&
                      groupState.group.description!.isNotEmpty)
                    Text(
                      groupState.group.description!,
                      style: TextStyle(
                          fontSize: AppSize.textMedium.sp,
                          color: Colors.black87),
                    ),
                  SizedBox(
                      height: groupState.group.description != null &&
                              groupState.group.description!.isNotEmpty
                          ? AppSize.apSectionMargin
                          : 0),
                  const Divider(),
                  const SizedBox(height: AppSize.apHorizontalPadding),

                  GroupDetailButtons(
                    membership: groupState.group.membership,
                  ),

                  const SizedBox(height: AppSize.apHorizontalPadding),
                  const Divider(),

                  const SizedBox(height: AppSize.apSectionMargin),
                  GroupDetailActivity(),
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
