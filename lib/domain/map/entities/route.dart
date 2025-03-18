import 'package:tracio_fe/data/map/models/route.dart';

class RouteEntity {
  int? routeId;
  int cyclistId;
  String cyclistName;
  String cyclistAvatar;
  String routeName;
  String routeThumbnail;
  GeoPoint startLocation;
  GeoPoint endLocation;
  List<GeoPoint> routePath;
  List<GeoPoint>? waypoints;
  int weighting;
  List<String>? avoidsRoads;
  bool optimizeRoute;
  double totalDistance;
  double elevationGain;
  double movingTime;
  double avgSpeed;
  int? mood;
  int reactionCounts;
  int difficulty;
  bool isPublic;
  bool isGroup;
  bool isDeleted;
  DateTime createdAt;

  RouteEntity({
    this.routeId,
    required this.cyclistId,
    required this.cyclistName,
    required this.cyclistAvatar,
    required this.routeName,
    required this.routeThumbnail,
    required this.startLocation,
    required this.endLocation,
    required this.routePath,
    this.waypoints,
    required this.weighting,
    this.avoidsRoads,
    required this.optimizeRoute,
    required this.totalDistance,
    required this.elevationGain,
    required this.movingTime,
    required this.avgSpeed,
    this.mood,
    this.reactionCounts = 0,
    required this.difficulty,
    this.isPublic = true,
    this.isGroup = false,
    this.isDeleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
