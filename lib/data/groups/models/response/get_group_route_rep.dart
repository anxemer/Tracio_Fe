import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracio_fe/domain/groups/entities/group_route.dart';

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
      required super.creator,
      required super.ridingRouteId});

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
      groupStatus: map['groupStatus'],
      totalCheckIn: map['checkIn'] ?? 0,
      participants: [], // You can fill this if participants are returned
      creator: Participant(
          userId: -1, userName: '', profilePicture: ''), // Placeholder
      ridingRouteId: -1, // Placeholder
    );
  }

  static double? _tryParseAltitude(dynamic alt) {
    if (alt == null || alt == "null") return null;
    return double.tryParse(alt.toString());
  }
}
