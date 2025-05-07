import 'package:Tracio/domain/map/entities/route.dart';

class GeoPoint {
  final double latitude;
  final double longitude;
  double? altitude;

  GeoPoint({required this.latitude, required this.longitude, this.altitude});

  Map<String, dynamic> toJson() =>
      {"latitude": latitude, "longitude": longitude, "altitude": altitude};

  static GeoPoint fromJson(Map<String, dynamic> json) {
    return GeoPoint(
      latitude: (json["latitude"] ?? 0.0).toDouble(),
      longitude: (json["longitude"] ?? 0.0).toDouble(),
      altitude: json["altitude"] == null
          ? null
          : (json["altitude"] is num)
              ? (json["altitude"] as num).toDouble()
              : double.tryParse(json["altitude"].toString()),
    );
  }
}

class RouteModel extends RouteEntity {
  RouteModel({
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
  });

  factory RouteModel.fromMap(Map<String, dynamic> map) {
    return RouteModel(
      routeId: map['routeId'],
      cyclistId: map['cyclistId'],
      cyclistName: map['cyclistName'],
      cyclistAvatar: map['cyclistAvatar'],
      routeName: map['routeName'],
      routeThumbnail: map['routeThumbnail'],
      description: map['description'],
      city: map['city'],
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
      reviewCounts: map['reviewCounts'] ?? 0,
      mediaFileCounts: map['mediaFileCounts'] ?? 0,
      privacyLevel: map['privacyLevel'] ?? 'public',
      isPlanned: map['isPlanned'] ?? false,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
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
