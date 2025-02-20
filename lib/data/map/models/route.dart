import 'dart:convert';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:tracio_fe/domain/map/entities/route.dart';

class RouteModel {
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

  RouteModel({
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

  // Convert a RouteModel instance to a map (for JSON serialization)
  Map<String, dynamic> toMap() {
    return {
      'route_id': routeId,
      'cyclist_id': cyclistId,
      'cyclist_name': cyclistName,
      'cyclist_avatar': cyclistAvatar,
      'route_name': routeName,
      'start_location': startLocation.toJson(),
      'end_location': endLocation.toJson(),
      'route_path': routePath.map((pos) => pos.toJson()).toList(),
      'waypoints': waypoints?.map((pos) => pos.toJson()).toList(),
      'weighting': weighting,
      'avoid': avoid?.toJson(),
      'avoids_roads': avoidsRoads != null ? jsonEncode(avoidsRoads) : null,
      'optimize_route': optimizeRoute,
      'total_distance': totalDistance,
      'elevation_gain': elevationGain,
      'moving_time': movingTime,
      'avg_speed': avgSpeed,
      'calories': calories,
      'mood': mood,
      'reaction_counts': reactionCounts,
      'difficulty': difficulty,
      'is_public': isPublic,
      'is_group': isGroup,
      'is_deleted': isDeleted,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Convert a map (from JSON) to a RouteModel instance
  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      routeId: map['route_id'],
      cyclistId: map['cyclist_id'],
      cyclistName: map['cyclist_name'],
      cyclistAvatar: map['cyclist_avatar'],
      routeName: map['route_name'],
      startLocation: Position.fromJson(map['start_location']),
      endLocation: Position.fromJson(map['end_location']),
      routePath: (map['route_path'] as List)
          .map((pos) => Position.fromJson(pos))
          .toList(),
      waypoints: (map['waypoints'] as List?)
          ?.map((pos) => Position.fromJson(pos))
          .toList(),
      weighting: map['weighting'],
      avoid: map['avoid'] != null ? Position.fromJson(map['avoid']) : null,
      avoidsRoads: map['avoids_roads'] != null
          ? List<String>.from(jsonDecode(map['avoids_roads']))
          : null,
      optimizeRoute: map['optimize_route'] ?? false,
      totalDistance: map['total_distance'],
      elevationGain: map['elevation_gain'],
      movingTime: map['moving_time'],
      avgSpeed: map['avg_speed'],
      calories: map['calories'],
      mood: map['mood'],
      reactionCounts: map['reaction_counts'] ?? 0,
      difficulty: map['difficulty'],
      isPublic: map['is_public'] ?? true,
      isGroup: map['is_group'] ?? false,
      isDeleted: map['is_deleted'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}

// Extension on Position to convert to/from JSON
extension PositionJson on geolocator.Position {
  Map<String, dynamic> toJson() {
    return {"latitude": latitude, "longitude": longitude};
  }

  static Position fromJson(Map<String, dynamic> json) {
    return Position(
      json["longitude"],
      json["latitude"],
    );
  }
}

extension RouteXModel on RouteModel {
  RouteEntity toEntity() {
    return RouteEntity(
        cyclistId: cyclistId,
        cyclistName: cyclistName,
        cyclistAvatar: cyclistAvatar,
        routeName: routeName,
        startLocation: startLocation,
        endLocation: endLocation,
        routePath: routePath,
        weighting: weighting,
        optimizeRoute: optimizeRoute,
        totalDistance: totalDistance,
        elevationGain: elevationGain,
        movingTime: movingTime,
        avgSpeed: avgSpeed,
        calories: calories,
        difficulty: difficulty);
  }
}
