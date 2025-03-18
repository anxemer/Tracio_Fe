import 'dart:convert';
import 'package:tracio_fe/domain/map/entities/route.dart';

class GeoPoint {
  final double latitude;
  final double longitude;
  double? altitude;

  GeoPoint({required this.latitude, required this.longitude, this.altitude});

  Map<String, dynamic> toJson() =>
      {"latitude": latitude, "longitude": longitude, "altitude": altitude};

  static GeoPoint fromJson(Map<String, dynamic> json) {
    return GeoPoint(
        latitude: json["latitude"] ?? 0.0,
        longitude: json["longitude"] ?? 0.0,
        altitude: json["altitude"] != 'null' ? json["altitude"] : null);
  }
}

class RouteModel extends RouteEntity {
  RouteModel(
      {super.routeId,
      required super.cyclistId,
      required super.cyclistName,
      required super.cyclistAvatar,
      required super.routeName,
      required super.routeThumbnail,
      required super.startLocation,
      required super.endLocation,
      required super.routePath,
      super.waypoints,
      required super.weighting,
      super.avoidsRoads,
      required super.optimizeRoute,
      required super.totalDistance,
      required super.elevationGain,
      required super.movingTime,
      required super.avgSpeed,
      super.mood,
      super.reactionCounts = 0,
      required super.difficulty,
      super.isPublic = true,
      super.isGroup = false,
      super.isDeleted = false,
      super.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'cyclistId': cyclistId,
      'cyclistName': cyclistName,
      'cyclistAvatar': cyclistAvatar,
      'routeName': routeName,
      'routeThumbnail': routeThumbnail,
      'startLocation': startLocation.toJson(),
      'endLocation': endLocation.toJson(),
      'routePath': routePath.map((pos) => pos.toJson()).toList(),
      'waypoints': waypoints?.map((pos) => pos.toJson()).toList(),
      'weighting': weighting,
      'avoidsRoads': avoidsRoads != null ? jsonEncode(avoidsRoads) : null,
      'optimizeRoute': optimizeRoute,
      'totalDistance': totalDistance,
      'elevationGain': elevationGain,
      'movingTime': movingTime,
      'avgSpeed': avgSpeed,
      'mood': mood,
      'reactionCounts': reactionCounts,
      'difficulty': difficulty,
      'isPublic': isPublic,
      'isGroup': isGroup,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convert a Map (from JSON) to a `RouteModel` instance
  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      routeId: map['routeId'],
      cyclistId: map['cyclistId'],
      cyclistName: map['user']?['username'] ?? 'Unknown',
      cyclistAvatar: map['user']?['avatar'] ?? '',
      routeName: map['routeName'] ?? 'Unnamed Route',
      routeThumbnail: map['routeThumbnail'] ?? '',
      startLocation: GeoPoint.fromJson(map['startLocation']),
      endLocation: GeoPoint.fromJson(map['endLocation']),
      routePath: (map['waypoints'] as List?)
              ?.map((pos) => GeoPoint.fromJson(pos))
              .toList() ??
          [],
      waypoints: (map['waypoints'] as List?)
          ?.map((pos) => GeoPoint.fromJson(pos))
          .toList(),
      weighting: map['weighting'] ?? 0,
      avoidsRoads: map['avoidsRoads'] != null
          ? List<String>.from(map['avoidsRoads'])
          : [],
      optimizeRoute: map['optimizeRoute'] ?? false,
      totalDistance: (map['totalDistance'] as num?)?.toDouble() ?? 0.0,
      elevationGain: (map['elevationGain'] as num?)?.toDouble() ?? 0.0,
      movingTime: (map['movingTime'] as num?)?.toDouble() ?? 0.0,
      avgSpeed: (map['avgSpeed'] as num?)?.toDouble() ?? 0.0,
      mood: map['mood'],
      reactionCounts: map['reactionCounts'] ?? 0,
      difficulty: map['difficulty'] ?? 1,
      isPublic: map['isPublic'] ?? true,
      isGroup: map['isGroup'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

extension RouteXModel on RouteModel {
  RouteEntity toEntity() {
    return RouteEntity(
        cyclistId: cyclistId,
        cyclistName: cyclistName,
        routeThumbnail: routeThumbnail,
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
        difficulty: difficulty);
  }
}
