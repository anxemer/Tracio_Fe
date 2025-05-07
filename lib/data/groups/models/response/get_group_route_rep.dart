import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:Tracio/domain/groups/entities/group_route.dart';

class GetGroupRouteRep extends GroupRouteEntity {
  GetGroupRouteRep(
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

  factory GetGroupRouteRep.fromMap(Map<String, dynamic> map) {
    return GetGroupRouteRep(
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
          alt: _tryParseAltitude(map['address']['altitude']),
        ),
        groupStatus: map['groupCheckinStatus'],
        totalCheckIn: map['totalCheckin'] ?? 0,
        participants: [],
        ridingRouteId: map['ridingRouteId'] ?? 0,
        creatorId: map['createdBy'] as int,
        creatorAvatarUrl: map['creatorAvatarUrl'],
        creatorName: map['creatorName'],
        groupRouteDetails: []);
  }

  static double? _tryParseAltitude(dynamic alt) {
    if (alt == null || alt == "null") return null;
    return double.tryParse(alt.toString());
  }
}
