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
      routeId: map['RouteId'],
      cyclistId: map['CyclistId'],
      cyclistName: map['User']?['Username'] ?? 'Unknown',
      cyclistAvatar: map['User']?['Avatar'] ?? '',
      routeName: map['RouteName'] ?? 'Unnamed Route',
      routeThumbnail: map['RouteThumbnail'] ?? '',
      startLocation: GeoPoint.fromJson(map['StartLocation']),
      endLocation: GeoPoint.fromJson(map['EndLocation']),
      routePath: (map['Waypoints'] as List?)
              ?.map((pos) => GeoPoint.fromJson(pos))
              .toList() ??
          [],
      waypoints: (map['Waypoints'] as List?)
          ?.map((pos) => GeoPoint.fromJson(pos))
          .toList(),
      weighting: map['Weighting'] ?? 0,
      avoidsRoads: map['AvoidsRoads'] != null
          ? List<String>.from(map['AvoidsRoads'])
          : [],
      optimizeRoute: map['OptimizeRoute'] ?? false,
      totalDistance: (map['TotalDistance'] as num?)?.toDouble() ?? 0.0,
      elevationGain: (map['ElevationGain'] as num?)?.toDouble() ?? 0.0,
      movingTime: (map['MovingTime'] as num?)?.toDouble() ?? 0.0,
      avgSpeed: (map['AvgSpeed'] as num?)?.toDouble() ?? 0.0,
      mood: map['Mood'],
      reactionCounts: map['ReactionCounts'] ?? 0,
      difficulty: map['Difficulty'] ?? 1,
      isPublic: map['IsPublic'] ?? true,
      isGroup: map['IsGroup'] ?? false,
      isDeleted: map['IsDeleted'] ?? false,
      createdAt: DateTime.tryParse(map['CreatedAt'] ?? '') ?? DateTime.now(),
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
