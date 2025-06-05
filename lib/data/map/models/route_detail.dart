import 'package:Tracio/data/map/models/route.dart';
import 'package:Tracio/domain/map/entities/route_detail.dart';

class RouteDetailModel extends RouteDetailEntity {
  RouteDetailModel(
      {required super.speeds,
      required super.distances,
      required super.altitudes,
      required super.timeStamps,
      required super.polyline,
      required super.polylineSummary,
      required super.movingTime,
      required super.stoppedTime,
      required super.maxSpeed,
      required super.highestElevation,
      required super.lowestElevation,
      required super.routeId,
      required super.cyclistId,
      required super.cyclistName,
      required super.cyclistAvatar,
      required super.routeName,
      required super.routeThumbnail,
      required super.description,
      required super.city,
      required super.origin,
      required super.destination,
      required super.waypoints,
      required super.totalDistance,
      required super.totalElevationGain,
      required super.totalDuration,
      required super.avgSpeed,
      required super.mood,
      required super.reactionCounts,
      required super.reviewCounts,
      required super.mediaFileCounts,
      required super.privacyLevel,
      required super.isPlanned,
      required super.createdAt,
      required super.updatedAt,
      required super.isOwner,
      required super.matchedUsers,
      required super.participants});
  factory RouteDetailModel.fromMap(Map<String, dynamic> map) {
    return RouteDetailModel(
      speeds: (map['speeds'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      distances: (map['distances'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      altitudes: (map['altitudes'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      timeStamps: List<int>.from(map['timestamps'] ?? []),
      polyline: map['polyline'] ?? '',
      polylineSummary: map['polylineSummary'] ?? '',
      movingTime: map['movingTime'] ?? 0,
      stoppedTime: map['stoppedTime'] ?? 0,
      maxSpeed: (map['maxSpeed'] ?? 0).toDouble(),
      highestElevation: (map['highestElevation'] ?? 0).toDouble(),
      lowestElevation: (map['lowestElevation'] ?? 0).toDouble(),
      routeId: map['routeId'],
      cyclistId: map['cyclistId'],
      cyclistName: map['cyclistName'] ?? '',
      cyclistAvatar: map['cyclistAvatar'] ?? '',
      routeName: map['routeName'] ?? '',
      routeThumbnail: map['routeThumbnail'] ?? '',
      description: map['description'] ?? '',
      city: map['city'] ?? '',
      origin: GeoPoint.fromJson(map['origin']),
      destination: GeoPoint.fromJson(map['destination']),
      waypoints: (map['waypoints'] as List)
          .map((e) => GeoPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalDistance: (map['totalDistance'] ?? 0).toDouble(),
      totalElevationGain: (map['totalElevationGain'] ?? 0).toDouble(),
      totalDuration: map['totalDuration'] ?? 0,
      avgSpeed: (map['avgSpeed'] ?? 0).toDouble(),
      mood: _parseMood(map['mood']),
      reactionCounts: map['reactionCounts'] ?? 0,
      reviewCounts: map['reviewCount'] ?? 0,
      mediaFileCounts: map['mediaFileCount'] ?? 0,
      privacyLevel: map['privacyLevel'] ?? "private",
      isPlanned: map['isPlanned'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isOwner: map['isOwner'] ?? false,
      matchedUsers: (map['matches'] as List<dynamic>?)
              ?.map((e) => MatchedUser.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      participants: (map['participants'] as List<dynamic>?)
              ?.map((e) => Participant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
  static int _parseMood(dynamic value) {
    switch (value.toString().toLowerCase()) {
      case 'happy':
        return 1;
      case 'neutral':
        return 2;
      case 'sad':
        return 3;
      default:
        return 0;
    }
  }
}
