import 'package:Tracio/common/helper/navigator/app_navigator.dart';
import 'package:Tracio/presentation/groups/widgets/activity/group_activity_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/domain/groups/entities/group_route.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        title: const Text("Group Activities"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
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
              child: _buildActivityList(state.groupRoutes.groupRouteList,
                  isPrivate: !state.group.isPublic),
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget _buildActivityList(List<GroupRouteEntity> groupRoutes,
      {bool isPrivate = false}) {
    if (groupRoutes.isEmpty && !isPrivate) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 150.h),
          Center(
            child: Column(
              children: [
                Icon(Icons.event_busy, size: 64.w, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  'No activities yet',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Be the first to create an activity!',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (isPrivate) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 150.h),
          Center(
            child: Column(
              children: [
                Icon(Icons.lock_outline, size: 64.w, color: Colors.grey),
                SizedBox(height: 16.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    'This is a private group',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    'You need to be a member to view activities',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: groupRoutes.length,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.w,
        bottom: 80.h,
      ),
      itemBuilder: (context, index) {
        final route = groupRoutes[index];
        if (route.groupStatus == "Deleted") {
          return const SizedBox.shrink();
        }

        return GestureDetector(
          onTap: () {
            AppNavigator.push(
              context,
              GroupActivityDetail(
                groupId: route.groupId,
                groupRouteId: route.groupRouteId,
              ),
            );
          },
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route Title and Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          route.title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildStatusChip(route.groupStatus),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Description
                  if (route.description.isNotEmpty) ...[
                    Text(
                      route.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],

                  // Date and Time
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 16.w, color: Colors.grey[600]),
                      SizedBox(width: 4.w),
                      Text(
                        route.formattedDate,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Icon(Icons.access_time,
                          size: 16.w, color: Colors.grey[600]),
                      SizedBox(width: 4.w),
                      Text(
                        route.formattedTime,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.place, size: 16.w, color: Colors.grey[600]),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          route.addressMeeting,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Divider(color: Colors.grey.shade200),

                  // Participants Section
                  Row(
                    children: [
                      Text(
                        "Participants",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "${route.participants.length}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Participants List
                  ...route.participants.map((p) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: Colors.grey.shade200,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: p.cyclistAvatarUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Icon(
                                    Icons.person,
                                    size: 20.w,
                                    color: Colors.grey.shade400,
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.person,
                                    size: 20.w,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    p.cyclistName,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Joined: ${p.formattedDate} ${p.formattedTime}",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (p.isOrganizer)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  "Organizer",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String text;

    switch (status) {
      case "NotStarted":
        color = Colors.blue;
        text = "Not started";
        break;
      case "Ongoing":
        color = Colors.green;
        text = "Ongoing";
        break;
      case "Finished":
        color = Colors.grey;
        text = "Finished";
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
