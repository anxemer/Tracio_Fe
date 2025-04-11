import 'package:flutter/material.dart';
import 'package:tracio_fe/common/widget/navbar/bottom_nav_bar_manager.dart';
import 'package:tracio_fe/core/constants/app_size.dart';
import 'package:tracio_fe/core/services/signalR/implement/group_route_hub_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tracio_fe/domain/groups/entities/group_route_location_update.dart';
import 'package:tracio_fe/domain/map/usecase/start_tracking_usecase.dart';
import 'package:tracio_fe/presentation/map/bloc/tracking_location_bloc.dart';
import 'package:tracio_fe/service_locator.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

class GroupActivityLoaded extends StatelessWidget {
  final int groupRouteId;
  final String title;
  final DateTime dateTime;
  final String tag;
  final String participantAvatarUrl;
  final int participantCount;

  const GroupActivityLoaded({
    super.key,
    required this.groupRouteId,
    required this.title,
    required this.dateTime,
    required this.tag,
    required this.participantAvatarUrl,
    required this.participantCount,
  });

  Future<void> _joinAndInvokeHub() async {
    final groupRouteHub = sl<GroupRouteHubService>();
    groupRouteHub.connect().then((_) {
      groupRouteHub.joinGroupRoute(groupRouteId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final day = dateTime.day;
    final month = _monthAbbreviation(dateTime.month);
    final weekday = _weekdayAbbreviation(dateTime.weekday);
    final time = TimeOfDay.fromDateTime(dateTime).format(context);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: AppSize.apSectionMargin / 3),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(AppSize.apHorizontalPadding),
          child: Row(
            children: [
              // Calendar Box
              Container(
                width: 60,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 8.0,
                        offset: Offset(1, 2),
                        color: Colors.grey.shade300,
                        spreadRadius: 1)
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(month.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1)),
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: double.maxFinite,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text('$day',
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            Text(weekday.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.directions_bike, size: 16),
                        const SizedBox(width: 4),
                        Text(time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    TextButton(
                        onPressed: () async {
                          await _joinAndInvokeHub();
                          context
                              .read<LocationCubit>()
                              .updateGroupRouteId(groupRouteId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: context.read<LocationCubit>(),
                                child: const BottomNavBarManager(
                                  selectedIndex: 2,
                                  isNavVisible: false,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text("Start ride"))
                  ],
                ),
              ),

              // Arrow Icon
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  String _monthAbbreviation(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _weekdayAbbreviation(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
}
