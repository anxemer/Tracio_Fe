import 'package:Tracio/data/map/models/route.dart';
import 'package:Tracio/domain/map/entities/route.dart';

class RouteDetailEntity extends RouteEntity {
  final List<double> speeds;
  final List<double> distances;
  final List<double> altitudes;
  final List<int> timeStamps;
  final String polyline;
  final String polylineSummary;
  final int movingTime;
  final int stoppedTime;
  double maxSpeed;
  double highestElevation;
  double lowestElevation;

  RouteDetailEntity({
    required this.speeds,
    required this.distances,
    required this.altitudes,
    required this.timeStamps,
    required this.polyline,
    required this.polylineSummary,
    required this.movingTime,
    required this.stoppedTime,
    required this.maxSpeed,
    required this.highestElevation,
    required this.lowestElevation,
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

  @override
  RouteDetailEntity copyWith({
    List<double>? speeds,
    List<double>? distances,
    List<double>? altitudes,
    List<int>? timeStamps,
    String? polyline,
    String? polylineSummary,
    int? movingTime,
    int? stoppedTime,
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
    double? maxSpeed,
    double? highestElevation,
    double? lowestElevation,
    int? mood,
    int? reactionCounts,
    int? reviewCounts,
    int? mediaFileCounts,
    String? privacyLevel,
    bool? isPlanned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RouteDetailEntity(
      speeds: speeds ?? this.speeds,
      distances: distances ?? this.distances,
      altitudes: altitudes ?? this.altitudes,
      timeStamps: timeStamps ?? this.timeStamps,
      polyline: polyline ?? this.polyline,
      polylineSummary: polylineSummary ?? this.polylineSummary,
      movingTime: movingTime ?? this.movingTime,
      stoppedTime: stoppedTime ?? this.stoppedTime,
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
      maxSpeed: maxSpeed ?? this.maxSpeed,
      highestElevation: highestElevation ?? this.highestElevation,
      lowestElevation: lowestElevation ?? this.lowestElevation,
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
