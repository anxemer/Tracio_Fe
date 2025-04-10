// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tracio_fe/data/map/models/route.dart';

class RouteEntity {
  int routeId;
  int cyclistId;
  String cyclistName;
  String cyclistAvatar;
  String routeName;
  String routeThumbnail;
  String? description;
  String? city;
  GeoPoint origin;
  GeoPoint destination;
  List<GeoPoint> waypoints;
  double totalDistance;
  double totalElevationGain;
  int totalDuration;
  double avgSpeed;
  int? mood;
  int reactionCounts;
  int reviewCounts;
  int mediaFileCounts;
  String privacyLevel;
  bool isPlanned;
  DateTime createdAt;
  DateTime updatedAt;
  RouteEntity({
    required this.routeId,
    required this.cyclistId,
    required this.cyclistName,
    required this.cyclistAvatar,
    required this.routeName,
    required this.routeThumbnail,
    required this.description,
    required this.city,
    required this.origin,
    required this.destination,
    required this.waypoints,
    required this.totalDistance,
    required this.totalElevationGain,
    required this.totalDuration,
    required this.avgSpeed,
    required this.mood,
    required this.reactionCounts,
    required this.reviewCounts,
    required this.mediaFileCounts,
    required this.privacyLevel,
    required this.isPlanned,
    required this.createdAt,
    required this.updatedAt,
  });

  RouteEntity copyWith({
    int? routeId,
    int? cyclistId,
    String? cyclistName,
    String? cyclistAvatar,
    String? routeName,
    String? routeThumbnail,
    String? description,
    String? city,
    GeoPoint? origin,
    GeoPoint? destination,
    List<GeoPoint>? waypoints,
    double? totalDistance,
    double? totalElevationGain,
    int? totalDuration,
    double? avgSpeed,
    int? mood,
    int? reactionCounts,
    int? reviewCounts,
    int? mediaFileCounts,
    String? privacyLevel,
    bool? isPlanned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RouteEntity(
      routeId: routeId ?? this.routeId,
      cyclistId: cyclistId ?? this.cyclistId,
      cyclistName: cyclistName ?? this.cyclistName,
      cyclistAvatar: cyclistAvatar ?? this.cyclistAvatar,
      routeName: routeName ?? this.routeName,
      routeThumbnail: routeThumbnail ?? this.routeThumbnail,
      description: description ?? this.description,
      city: city ?? this.city,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      waypoints: waypoints ?? this.waypoints,
      totalDistance: totalDistance ?? this.totalDistance,
      totalElevationGain: totalElevationGain ?? this.totalElevationGain,
      totalDuration: totalDuration ?? this.totalDuration,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      mood: mood ?? this.mood,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      reviewCounts: reviewCounts ?? this.reviewCounts,
      mediaFileCounts: mediaFileCounts ?? this.mediaFileCounts,
      privacyLevel: privacyLevel ?? this.privacyLevel,
      isPlanned: isPlanned ?? this.isPlanned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
