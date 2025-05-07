import 'package:Tracio/domain/map/entities/route_blog.dart';

class RouteBlogModel extends RouteBlogEntity {
  RouteBlogModel(
      {required super.routeId,
      required super.cyclistId,
      required super.cyclistName,
      required super.cyclistAvatar,
      required super.routeName,
      required super.routeThumbnail,
      required super.description,
      required super.city,
      required super.totalDistance,
      required super.totalElevationGain,
      required super.totalDuration,
      required super.avgSpeed,
      required super.mood,
      required super.isPublic,
      required super.isPlanned,
      required super.createdAt,
      required super.updatedAt,
      required super.isReacted});

  factory RouteBlogModel.fromMap(Map<String, dynamic> map) {
    return RouteBlogModel(
      routeId: map['routeId'],
      cyclistId: map['cyclistId'],
      cyclistName: map['cyclistName'],
      cyclistAvatar: map['cyclistAvatar'],
      routeName: map['routeName'],
      routeThumbnail: map['routeThumbnail'],
      description: map['description'],
      city: map['city'],
      totalDistance: map['totalDistance'].toDouble(),
      totalElevationGain: map['totalElevationGain'].toDouble(),
      totalDuration: map['totalDuration'],
      avgSpeed: map['avgSpeed'].toDouble(),
      mood: map['mood'],
      isPublic: map['isPublic'],
      isPlanned: map['isPlanned'],
      isReacted: map['isReacted'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
