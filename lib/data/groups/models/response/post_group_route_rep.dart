import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracio_fe/domain/groups/entities/group_route.dart';

class PostGroupRouteRep extends GroupRouteEntity {
  PostGroupRouteRep(
      {required super.groupRouteId,
      required super.routeId,
      required super.groupId,
      required super.title,
      required super.description,
      required super.startDateTime,
      required super.addressMeeting,
      required super.address,
      required super.groupStatus,
      required super.totalCheckIn,
      required super.participants,
      required super.ridingRouteId,
      required super.creatorId,
      required super.creatorAvatarUrl,
      required super.creatorName,
      required super.groupRouteDetails});

  factory PostGroupRouteRep.fromMap(Map<String, dynamic> map) {
    return PostGroupRouteRep(
        groupRouteId: map['groupRouteId'],
        routeId: map['routeId'],
        groupId: map['groupId'],
        title: map['title'],
        description: map['description'],
        startDateTime: DateTime.parse(map['startTime']),
        addressMeeting: map['addressMeeting'],
        address: Position.named(
          lat: map['address']['latitude'],
          lng: map['address']['longitude'],
          alt: double.tryParse(map['address']['altitude'].toString()),
        ),
        groupStatus: map['groupStatus'],
        totalCheckIn: map['totalCheckin'],
        participants: [],
        ridingRouteId: map['ridingRouteId'] ?? 0,
        creatorId: map['creatorId'],
        creatorAvatarUrl: map['creatorAvatarUrl'],
        creatorName: map['creatorName'],
        groupRouteDetails: []);
  }
}
