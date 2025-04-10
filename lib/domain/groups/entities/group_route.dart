import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class GroupRouteEntity {
  final int groupRouteId;
  final int routeId;
  final int groupId;
  final String title;
  final String description;
  final DateTime startDateTime;
  final String addressMeeting;
  final Position address;
  final String groupStatus;
  final int totalCheckIn;
  final List<Participant> participants;
  final Participant creator;
  final int ridingRouteId;
  GroupRouteEntity({
    required this.groupRouteId,
    required this.routeId,
    required this.groupId,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.addressMeeting,
    required this.address,
    required this.groupStatus,
    required this.totalCheckIn,
    required this.participants,
    required this.creator,
    required this.ridingRouteId,
  });

  String get formattedDate {
    return "${startDateTime.day}-${startDateTime.month}-${startDateTime.year}";
  }

  String get formattedTime {
    return "${startDateTime.hour}:${startDateTime.minute}";
  }
}

class Participant {
  int userId;
  String userName;
  String profilePicture;
  Participant({
    required this.userId,
    required this.userName,
    required this.profilePicture,
  });

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      userId: map['userId'] as int,
      userName: map['userName'] as String,
      profilePicture: map['profilePicture'] as String,
    );
  }
}
