import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:Tracio/data/map/models/route_blog.dart';
import 'package:Tracio/domain/groups/entities/group_route.dart';

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
      required super.groupCheckinStatus,
      required super.participants,
      required super.ridingRouteId,
      required super.creatorId,
      required super.creatorAvatarUrl,
      required super.creatorName,
      required super.groupRouteDetails,
      required super.ridingRoute});

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
        alt: _tryParseAltitude(map['address']['altitude']),
      ),
      groupStatus: map['groupCheckinStatus'],
      totalCheckIn: map['totalCheckin'] ?? 0,
      groupCheckinStatus: map['groupCheckinStatus'] ?? "NotStated",
      participants: [],
      ridingRouteId: map['ridingRouteId'],
      ridingRoute: map['ridingRoute'] != null
          ? RouteBlogModel.fromMap(map['ridingRoute'])
          : null, // ✅ safely mapped
      creatorId: map['createdBy'] as int,
      creatorAvatarUrl: map['creatorAvatarUrl'],
      creatorName: map['creatorName'],
      groupRouteDetails: [],
    );
  }

  static double? _tryParseAltitude(dynamic alt) {
    if (alt == null || alt == "null") return null;
    return double.tryParse(alt.toString());
  }
}
