import 'package:Tracio/data/auth/sources/auth_local_source/auth_local_source.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/widgets/detail/route_plan_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/common/widget/navbar/bottom_nav_bar_manager.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/core/services/signalR/implement/group_route_hub_service.dart';
import 'package:Tracio/domain/groups/entities/group_route.dart';
import 'package:Tracio/domain/map/entities/route_blog.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_state.dart';
import 'package:Tracio/presentation/groups/widgets/activity/calendar_box.dart';
import 'package:Tracio/presentation/library/pages/route_detail.dart';
import 'package:Tracio/presentation/map/bloc/map_cubit.dart';
import 'package:Tracio/presentation/map/bloc/tracking/bloc/tracking_bloc.dart';
import 'package:Tracio/service_locator.dart';

class GroupActivityDetail extends StatefulWidget {
  final int groupId;
  final int groupRouteId;
  const GroupActivityDetail(
      {super.key, required this.groupId, required this.groupRouteId});

  @override
  State<GroupActivityDetail> createState() => _GroupActivityDetailState();
}

class _GroupActivityDetailState extends State<GroupActivityDetail> {
  final int _calendarBoxWidth = 60;
  final int _calendarBoxHeight = 70;
  final int _imageHeight = 200;
  final int _imageRouteHeight = 180;
  bool _isCreator = false;

  Future<void> _onRefresh() async {
    if (!mounted) return;
    var state = context.read<GroupCubit>().state as GetGroupDetailSuccess;
    context.read<GroupCubit>().getGroupRouteDetail(widget.groupRouteId, state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GroupCubit, GroupState>(
        listener: (context, state) {
          if (state is DeleteGroupRouteSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Route deleted successfully'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GetGroupDetailSuccess) {
            final groupRoute = state.groupRoutes.groupRouteList
                .firstWhere((p) => p.groupRouteId == widget.groupRouteId);
            _isCreator =
                groupRoute.creatorId == sl<AuthLocalSource>().getUser()?.userId;
            if (groupRoute.groupStatus == "Deleted") {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: const Text('Route Deleted'),
                    content: const Text('This activity has been deleted.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Navigate back
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              });
              return const SizedBox.shrink();
            }
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        _buildHeaderImage(groupRoute.startDateTime),
                        _buildGroupInfo(
                            state.group.groupName, groupRoute.title),
                        _buildScheduleInfo(groupRoute),
                        const Divider(),
                        const SizedBox(height: AppSize.apSectionMargin),
                        _buildRouteOverview(groupRoute),
                        const SizedBox(height: AppSize.apSectionMargin),
                        _buildMemberActivities(state),
                        const SizedBox(height: AppSize.apSectionMargin),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildAppBar(),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeaderImage(DateTime startDateTime) {
    return SizedBox(
      height: _imageHeight + _calendarBoxHeight.h,
      child: Stack(
        children: [
          _buildGreyBackgroundImage(height: _imageHeight.h),
          Positioned(
            bottom: 0,
            left:
                MediaQuery.of(context).size.width / 2 - _calendarBoxWidth / 2.w,
            child: Container(
              margin: EdgeInsets.only(bottom: 8.h),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  blurRadius: 8.0,
                  offset: const Offset(1, 2),
                  color: Colors.grey.shade300,
                  spreadRadius: 1,
                )
              ]),
              child: CalendarBox(startDateTime: startDateTime),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreyBackgroundImage({required double height}) {
    return Container(
      width: double.infinity,
      height: height,
      color: Colors.grey.shade500,
      child: Image.asset(
        "assets/images/abstract-terrain-map.png",
        fit: BoxFit.cover,
        opacity: const AlwaysStoppedAnimation(0.5),
      ),
    );
  }

  Widget _buildGroupInfo(String groupName, String title) {
    return Column(
      children: [
        Text(
          groupName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: AppSize.textHeading * 0.7.sp),
        ),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: AppSize.textHeading * 0.8.sp,
          ),
        ),
        const SizedBox(height: AppSize.apSectionMargin),
      ],
    );
  }

  Widget _buildScheduleInfo(GroupRouteEntity groupRoute) {
    bool isDisabled = isLessThan30MinutesFromNow(groupRoute.startDateTime) &&
        isAlreadyInGroupTracking();
    if (groupRoute.groupStatus == "Finished") {
      isDisabled = true;
    }
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
      child: Column(
        children: [
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 8.0),
                  Text(
                      "${groupRoute.formattedDate} ${groupRoute.formattedTime}"),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 8.0),
                  Flexible(
                    child: Text(
                      groupRoute.addressMeeting,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSize.apSectionMargin),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "Can start before 30 minutes",
              style: TextStyle(
                fontSize: AppSize.textSmall.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          _buildActionButton(
              disabled: isDisabled,
              groupRoute.groupStatus == "Finished"
                  ? "This activity has finished"
                  : "Start Riding",
              Icons.start_sharp, () async {
            try {
              final groupRouteHub = sl<GroupRouteHubService>();
              await groupRouteHub.connect();
              await groupRouteHub
                  .joinGroupRoute(widget.groupRouteId.toString());

              if (!context.mounted) return;

              // Get the TrackingBloc before navigation
              final trackingBloc = context.read<TrackingBloc>();

              // Navigate to cycling page
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return BlocProvider.value(
                  value: trackingBloc
                    ..add(AddGroupRouteId(widget.groupRouteId)),
                  child: BottomNavBarManager(
                    selectedIndex: 1,
                    isNavVisible: false,
                  ),
                );
              }));
            } catch (e, stack) {
              debugPrint("❌ Failed to start riding: $e\n$stack");
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Failed to connect to ride. Please try again.')),
                );
              }
            }
          }),
        ],
      ),
    );
  }

  Widget _buildRouteOverview(GroupRouteEntity groupRoute) {
    if (groupRoute.ridingRoute != null) {
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Route Overview",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: AppSize.textMedium.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSize.apVerticalPadding),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                        create: (context) => MapCubit(),
                        child: BlocProvider.value(
                            value: context.read<RouteCubit>()
                              ..getRouteDetail(groupRoute.ridingRoute!.routeId),
                            child: RoutePlanDetail(
                              routeId: groupRoute.ridingRoute!.routeId,
                            ))),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: groupRoute.ridingRoute!.routeThumbnail,
                      width: double.infinity,
                      height: _imageRouteHeight * 0.8.h,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          _buildGreyBackgroundImage(
                              height: _imageRouteHeight * 0.8.h),
                    ),
                    const SizedBox(height: AppSize.apVerticalPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatText("Distance:",
                            "${groupRoute.ridingRoute!.totalDistance.toStringAsFixed(1)} km"),
                        _buildStatText("Elev. Gain:",
                            "${groupRoute.ridingRoute!.totalElevationGain.toStringAsFixed(1)} m"),
                      ],
                    ),
                    const SizedBox(height: AppSize.apVerticalPadding),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildStatText(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: AppSize.textMedium.sp),
        ),
        const SizedBox(width: 4.0),
        Text(
          value,
          style: TextStyle(
            fontSize: AppSize.textMedium.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMemberActivities(GetGroupDetailSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSize.apHorizontalPadding),
          child: Text(
            "Activity Summary",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: AppSize.textMedium.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: AppSize.apVerticalPadding),
        if (state.groupRouteDetails.isEmpty)
          Align(
            alignment: Alignment.center,
            child: Text(
              "This activity has not started yet",
              style: TextStyle(
                  fontSize: AppSize.textSmall.sp, color: Colors.grey.shade500),
            ),
          )
        else
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.groupRouteDetails.length,
              itemBuilder: (_, index) {
                return Ink(
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.only(
                      bottom: AppSize.apVerticalPadding / 2),
                  child: _buildMemberActivityCard(
                      state.groupRouteDetails[index].ridingRoute),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildMemberActivityCard(RouteBlogEntity detail) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => MapCubit(),
              child: BlocProvider.value(
                value: context.read<GroupCubit>(),
                child: BlocProvider.value(
                  value: context.read<RouteCubit>()
                    ..getRouteDetail(detail.routeId),
                  child: RouteDetailScreen(routeId: detail.routeId),
                ),
              ),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            _buildThumbnail(detail.routeThumbnail),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(detail),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildStatChip("${detail.totalDistance} km", Icons.route),
                      _buildStatChip("${detail.avgSpeed} km/h", Icons.speed),
                      _buildStatChip(
                          _formatDuration(detail.totalDuration), Icons.timer),
                      _buildStatChip(
                          "${detail.totalElevationGain} m", Icons.terrain),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String url) {
    return SizedBox(
      width: 60.w,
      height: 60.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.fill,
          placeholder: (context, url) => _buildPlaceholderIcon(Icons.image),
          errorWidget: (context, url, error) =>
              _buildPlaceholderIcon(Icons.broken_image),
        ),
      ),
    );
  }

  Widget _buildUserInfo(RouteBlogEntity detail) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14.w,
          backgroundColor: Colors.grey.shade300,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: detail.cyclistAvatar,
              fit: BoxFit.cover,
              width: 28.w,
              height: 28.w,
              placeholder: (context, url) =>
                  _buildPlaceholderIcon(Icons.person),
              errorWidget: (context, url, error) =>
                  _buildPlaceholderIcon(Icons.person),
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Text(
          detail.cyclistName,
          style: TextStyle(
            fontSize: AppSize.textMedium.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderIcon(IconData icon) {
    return Container(
      color: Colors.grey.shade300,
      child: Icon(icon, color: Colors.white, size: 18.0),
    );
  }

  String _formatDuration(int milliseconds) {
    final seconds = milliseconds ~/ 1000;
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return "${hours}h ${minutes}m";
  }

  PreferredSizeWidget _buildAppBar() {
    return BasicAppbar(
      hideBack: true,
      backgroundColor: Colors.transparent,
      height: AppSize.appBarHeight.h,
      action: _buildActionIcons(),
    );
  }

  Widget _buildActionIcons() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSize.apHorizontalPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(),
          if (_isCreator) _buildMenuButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return IconButton(
      style: IconButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Colors.white,
      ),
      padding: EdgeInsets.zero,
      onPressed: () => Navigator.pop(context),
      icon: Icon(Icons.arrow_back_rounded,
          color: Colors.black87, size: AppSize.iconMedium.w),
    );
  }

  Widget _buildMenuButton() {
    return PopupMenuButton<String>(
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white)),
      tooltip: "More",
      icon: Icon(Icons.more_vert,
          color: Colors.black87, size: AppSize.iconMedium.w),
      color: Colors.white,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) async {
        if (value == 'edit') {
          // TODO: Handle edit event
        } else if (value == 'delete') {
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Route'),
              content: const Text(
                  'Are you sure you want to delete this route? This action cannot be undone.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );

          if (shouldDelete == true && context.mounted) {
            context.read<GroupCubit>().deleteGroupRoute(
                  widget.groupId,
                  widget.groupRouteId,
                );
          }
        }
      },
      itemBuilder: (context) => [
        _buildPopupMenuItem('edit', Icons.edit_note_outlined, "Edit Activity"),
        _buildPopupMenuItem('delete', Icons.delete_outline, "Delete Activity",
            iconColor: Colors.redAccent),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      String value, IconData icon, String text,
      {Color iconColor = Colors.black54}) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  bool isLessThan30MinutesFromNow(DateTime startDateTime) {
    final now = DateTime.now();
    final difference = startDateTime.difference(now).inMinutes;
    return difference >= 0 && difference < 30;
  }

  bool isAlreadyInGroupTracking() {
    final joinedGroupRoutes = sl<GroupRouteHubService>().joinedGroupRouteIds;
    return joinedGroupRoutes.isNotEmpty;
  }

  SizedBox _buildActionButton(
    String text,
    IconData icon,
    VoidCallback onTap, {
    bool outline = false,
    bool disabled = false,
  }) {
    final Color backgroundColor = disabled
        ? Colors.grey.shade300
        : (outline ? Colors.white : AppColors.secondBackground);

    final Color textColor = disabled
        ? Colors.grey.shade500
        : (outline ? AppColors.primary : Colors.white);

    final VoidCallback? effectiveOnTap = disabled ? null : onTap;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(
              vertical: AppSize.apVerticalPadding * 0.8),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: disabled
                  ? Colors.transparent
                  : (outline ? AppColors.primary : Colors.transparent),
              width: outline ? 1.0 : 0.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: effectiveOnTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: textColor,
              size: AppSize.iconMedium.w,
            ),
            const SizedBox(width: 8.0),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: AppSize.textLarge.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
