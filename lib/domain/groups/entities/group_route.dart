import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:Tracio/data/map/models/route_blog.dart';
import 'package:Tracio/domain/map/entities/route_blog.dart';

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
  final int? ridingRouteId;
  final int creatorId;
  final String creatorName;
  final String creatorAvatarUrl;
  final List<GroupRouteDetail> groupRouteDetails;
  GroupRouteEntity(
      {required this.groupRouteId,
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
      required this.ridingRouteId,
      required this.creatorId,
      required this.creatorName,
      required this.creatorAvatarUrl,
      required this.groupRouteDetails});

  String get formattedDate {
    return "${startDateTime.day}-${startDateTime.month}-${startDateTime.year}";
  }

  String get formattedTime {
    return "${startDateTime.hour}:${startDateTime.minute}";
  }
}

class Participant {
  int cyclistId;
  String cyclistName;
  String cyclistAvatarUrl;
  bool isOrganizer;
  DateTime joinAt;
  String followStatus;
  Participant(
      {required this.cyclistId,
      required this.cyclistName,
      required this.cyclistAvatarUrl,
      required this.isOrganizer,
      required this.joinAt,
      required this.followStatus});

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      cyclistId: map['cyclistId'] as int,
      cyclistName: map['cyclistName'] as String,
      cyclistAvatarUrl: map['cyclistAvatarUrl'] as String,
      isOrganizer: map['isOrganizer'] as bool,
      joinAt: DateTime.parse(map['joinAt'] as String),
      followStatus: map['followStatus'] as String,
    );
  }

  String get formattedDate {
    return "${joinAt.day}-${joinAt.month}-${joinAt.year}";
  }

  String get formattedTime {
    return "${joinAt.hour}:${joinAt.minute}";
  }
}

class GroupRouteDetail {
  final int groupRouteDetailId;
  final int ridingRouteId;
  DateTime checkInAt;
  Cyclist cyclist;
  RouteBlogEntity ridingRoute;
  GroupRouteDetail({
    required this.groupRouteDetailId,
    required this.ridingRouteId,
    required this.checkInAt,
    required this.cyclist,
    required this.ridingRoute,
  });

  GroupRouteDetail copyWith({
    int? groupRouteDetailId,
    int? ridingRouteId,
    DateTime? checkInAt,
    Cyclist? cyclist,
    RouteBlogEntity? ridingRoute,
  }) {
    return GroupRouteDetail(
      groupRouteDetailId: groupRouteDetailId ?? this.groupRouteDetailId,
      ridingRouteId: ridingRouteId ?? this.ridingRouteId,
      checkInAt: checkInAt ?? this.checkInAt,
      cyclist: cyclist ?? this.cyclist,
      ridingRoute: ridingRoute ?? this.ridingRoute,
    );
  }

  factory GroupRouteDetail.fromMap(Map<String, dynamic> map) {
    return GroupRouteDetail(
      groupRouteDetailId: map['groupRouteDetailId'] as int,
      ridingRouteId: map['ridingRouteId'] as int,
      checkInAt: DateTime.parse(map['checkInAt'] as String),
      cyclist: Cyclist.fromMap(map['cyclist'] as Map<String, dynamic>),
      ridingRoute:
          RouteBlogModel.fromMap(map['ridingRoute'] as Map<String, dynamic>),
    );
  }
}

class Cyclist {
  final int userId;
  final String userName;
  final String profilePicture;
  Cyclist({
    required this.userId,
    required this.userName,
    required this.profilePicture,
  });

  factory Cyclist.fromMap(Map<String, dynamic> map) {
    return Cyclist(
      userId: map['userId'] as int,
      userName: map['userName'] as String,
      profilePicture: map['profilePicture'] as String,
    );
  }
}
