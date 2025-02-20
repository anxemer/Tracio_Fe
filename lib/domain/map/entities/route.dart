import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class RouteEntity {
  int? routeId;
  int cyclistId;
  String cyclistName;
  String cyclistAvatar;
  String routeName;
  Position startLocation; // Using geolocator's Position for POINT
  Position endLocation; // Using geolocator's Position for POINT
  List<Position> routePath; // Using List<Position> for LINESTRING
  List<Position>? waypoints; // Optional waypoints
  int weighting; // 0: Shortest, 1: Fastest, 2: Balanced
  Position? avoid; // Optional avoid point
  List<String>? avoidsRoads; // JSON representation of avoided roads
  bool optimizeRoute;
  double totalDistance;
  double elevationGain;
  double movingTime;
  double avgSpeed;
  double calories;
  int? mood; // Optional mood
  int reactionCounts;
  int difficulty; // Difficulty of the route
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
    required this.startLocation,
    required this.endLocation,
    required this.routePath,
    this.waypoints,
    required this.weighting,
    this.avoid,
    this.avoidsRoads,
    required this.optimizeRoute,
    required this.totalDistance,
    required this.elevationGain,
    required this.movingTime,
    required this.avgSpeed,
    required this.calories,
    this.mood,
    this.reactionCounts = 0,
    required this.difficulty,
    this.isPublic = true,
    this.isGroup = false,
    this.isDeleted = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
