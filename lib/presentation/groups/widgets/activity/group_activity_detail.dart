import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/common/widget/appbar/app_bar.dart';
import 'package:Tracio/core/configs/theme/app_colors.dart';
import 'package:Tracio/core/constants/app_size.dart';
import 'package:Tracio/domain/groups/entities/group_route.dart';
import 'package:Tracio/domain/map/entities/route_blog.dart';
import 'package:Tracio/presentation/groups/cubit/group_cubit.dart';
import 'package:Tracio/presentation/groups/cubit/group_state.dart';
import 'package:Tracio/presentation/groups/widgets/activity/calendar_box.dart';
import 'package:Tracio/presentation/library/pages/route_detail.dart';
import 'package:Tracio/presentation/library/widgets/route_blog_item.dart';
import 'package:Tracio/presentation/map/bloc/route_cubit.dart';
import 'package:Tracio/presentation/map/bloc/route_state.dart';

class GroupActivityDetail extends StatefulWidget {
  final int groupRouteId;
  const GroupActivityDetail({super.key, required this.groupRouteId});

  @override
  State<GroupActivityDetail> createState() => _GroupActivityDetailState();
}

class _GroupActivityDetailState extends State<GroupActivityDetail> {
  final int _calendarBoxWidth = 60;
  final int _calendarBoxHeight = 70;
  final int _statBoxHeight = 80;
  final int _imageHeight = 200;
  final int _imageRouteHeight = 180;

  Future<void> _onRefresh() async {
    if (!mounted) return;
    context.read<GroupCubit>().getGroupRouteDetail(widget.groupRouteId);
    context.read<RouteCubit>().getRouteBlogList();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => {context.read<RouteCubit>().getRouteBlogList()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state is GetGroupDetailSuccess) {
            final groupRoute = state.groupRoutes
                .firstWhere((p) => p.groupRouteId == widget.groupRouteId);

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
                        // _buildMemberActivities(state),
                        const SizedBox(height: AppSize.apSectionMargin),
                        Container(
                          color: Colors.grey.shade200,
                          child: BlocBuilder<RouteCubit, RouteState>(
                            builder: (context, routeState) {
                              if (routeState is GetRouteBlogLoaded &&
                                  routeState.routeBlogs.isNotEmpty) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: routeState.routeBlogs.length,
                                  itemBuilder: (_, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom:
                                              AppSize.apVerticalPadding / 2),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: _buildMemberActivityCard(
                                          routeState.routeBlogs[index],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else if (routeState is GetRouteBlogLoaded &&
                                  routeState.routeBlogs.isEmpty) {
                                return Center(child: Text("Nothing here"));
                              }
                              if (routeState is GetRouteBlogLoading) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.secondBackground,
                                  ),
                                );
                              }

                              return Text("Error");
                            },
                          ),
                        ),
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
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSize.apHorizontalPadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${groupRoute.formattedDate} ${groupRoute.formattedTime}"),
              Text(groupRoute.addressMeeting),
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
          _buildActionButton("Start Riding", Icons.start_sharp, () {
            //TODO: Connect hub => navigate to cycling
          }, outline: true, disabled: true),
        ],
      ),
    );
  }

  Widget _buildRouteOverview(GroupRouteEntity groupRoute) {
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
            onTap: () {},
            child: Container(
              width: double.infinity,
              height: _imageRouteHeight * 0.8 + _statBoxHeight.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  // _buildGreyBackgroundImage(height: _imageRouteHeight * 0.8.h),
                  CachedNetworkImage(
                    imageUrl:
                        "https://api.mapbox.com/styles/v1/mapbox/streets-v12/static/path-5+f44-0.5(io%7B%60A%7B~jjSpCzDsFrFyGeJi@wRcGN~AjUmRlw@lM%7Ca@ri@%60h@hKeM%60OmGtG~FlGqHj]~[zHgGfK%7CI%60EmEkMsL)/auto/500x300?access_token=pk.eyJ1IjoidHJtaW5sb2MiLCJhIjoiY203MWU3NmdjMGE2azJwczh5Nzd2c2VmaCJ9.llG8qqDi6cylYa7mVdLWag",
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: AppSize.imageSmall / 2.4.w,
                      child: Icon(
                        Icons.person,
                        size: AppSize.imageSmall / 2.w,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSize.apVerticalPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatText("Distance", "7.2 km"),
                      _buildStatText("Elev. Gain", "32 ft"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatText(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: AppSize.textMedium.sp),
        ),
        const SizedBox(width: 8.0),
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
            builder: (context) => BlocProvider.value(
              value: context.read<GroupCubit>(),
              child: RouteDetailScreen(routeId: detail.routeId),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _buildThumbnail(detail.routeThumbnail),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(detail),
                  const SizedBox(height: 4.0),
                  Wrap(
                    spacing: 4.0,
                    children: [
                      Text("${detail.totalDistance} km"),
                      Text("${detail.avgSpeed} km/h"),
                      Text("${_formatDuration(detail.totalDuration)} hrs"),
                      Text("${detail.totalElevationGain} m"),
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
          radius: 16.w,
          backgroundColor: Colors.grey.shade300,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: detail.cyclistAvatar,
              fit: BoxFit.cover,
              width: 32.w,
              height: 32.w,
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
          _buildMenuButton(),
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
      onSelected: (value) {
        if (value == 'edit') {
          // TODO: Handle edit event
        } else if (value == 'delete') {
          // TODO: Handle delete event
        }
      },
      itemBuilder: (context) => [
        _buildPopupMenuItem('edit', Icons.edit_note_outlined, "Edit Event"),
        _buildPopupMenuItem('delete', Icons.delete_outline, "Delete Event",
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
