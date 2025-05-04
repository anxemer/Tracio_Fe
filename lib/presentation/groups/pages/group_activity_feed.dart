import 'package:flutter/material.dart';
import 'package:tracio_fe/domain/groups/entities/group_route.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class GroupActivityFeed extends StatefulWidget {
  final int groupId;

  const GroupActivityFeed({super.key, required this.groupId});

  @override
  State<GroupActivityFeed> createState() => _GroupActivityFeedState();
}

class _GroupActivityFeedState extends State<GroupActivityFeed> {
  final List<GroupRouteEntity> groupRoutes = [
    GroupRouteEntity(
      groupRouteId: 1,
      routeId: 101,
      groupId: 10,
      title: "Sunday Morning Ride",
      description:
          "Join us for a scenic ride through the city and countryside.",
      startDateTime: DateTime.now().add(const Duration(days: 1, hours: 2)),
      addressMeeting: "123 Riverside Park, District 7",
      address: Position(106.700981, 10.762622), // lat-lng (lon, lat)
      groupStatus: "Scheduled",
      totalCheckIn: 3,
      ridingRouteId: 5001,
      creatorId: 100,
      creatorName: "Alice Nguyen",
      creatorAvatarUrl: "https://i.pravatar.cc/150?img=1",
      groupRouteDetails: [],
      participants: [
        Participant(
          cyclistId: 100,
          cyclistName: "Alice Nguyen",
          cyclistAvatarUrl: "https://i.pravatar.cc/150?img=1",
          isOrganizer: true,
          joinAt: DateTime.now().subtract(const Duration(days: 1)),
          followStatus: "Following",
        ),
        Participant(
          cyclistId: 101,
          cyclistName: "Bob Tran",
          cyclistAvatarUrl: "https://i.pravatar.cc/150?img=2",
          isOrganizer: false,
          joinAt: DateTime.now().subtract(const Duration(hours: 6)),
          followStatus: "NotFollowing",
        ),
        Participant(
          cyclistId: 102,
          cyclistName: "Carol Le",
          cyclistAvatarUrl: "https://i.pravatar.cc/150?img=3",
          isOrganizer: false,
          joinAt: DateTime.now().subtract(const Duration(hours: 2)),
          followStatus: "Following",
        ),
      ],
    ),
    GroupRouteEntity(
      groupRouteId: 2,
      routeId: 102,
      groupId: 11,
      title: "Evening Challenge Ride",
      description: "Push your limits with this moderate-intensity group ride.",
      startDateTime: DateTime.now().add(const Duration(days: 2, hours: 3)),
      addressMeeting: "Saigon Zoo, District 1",
      address: Position(106.7123, 10.7891),
      groupStatus: "Open",
      totalCheckIn: 2,
      ridingRouteId: 5002,
      creatorId: 101,
      creatorName: "Bob Tran",
      creatorAvatarUrl: "https://i.pravatar.cc/150?img=2",
      groupRouteDetails: [],
      participants: [
        Participant(
          cyclistId: 101,
          cyclistName: "Bob Tran",
          cyclistAvatarUrl: "https://i.pravatar.cc/150?img=2",
          isOrganizer: true,
          joinAt: DateTime.now().subtract(const Duration(days: 2)),
          followStatus: "Following",
        ),
        Participant(
          cyclistId: 103,
          cyclistName: "David Pham",
          cyclistAvatarUrl: "https://i.pravatar.cc/150?img=4",
          isOrganizer: false,
          joinAt: DateTime.now().subtract(const Duration(hours: 10)),
          followStatus: "NotFollowing",
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Activity Feed"),
      ),
      body: ListView.builder(
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
      ),
    );
  }
}
