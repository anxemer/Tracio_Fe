// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Tracio/data/map/models/route.dart';

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

  String formatDateTime(DateTime dateTime) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    String month = months[dateTime.month - 1];
    String day = dateTime.day.toString();
    String year = dateTime.year.toString();

    int hour = dateTime.hour;
    String minute = dateTime.minute < 10
        ? '0${dateTime.minute}'
        : dateTime.minute.toString();

    String amPm = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;

    return '$month $day, $year at $hour:$minute $amPm';
  }

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

class RoutePaginationEntity {
  List<RouteEntity> routes;
  int totalCount;
  int pageNumber;
  int pageSize;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;
  RoutePaginationEntity({
    required this.routes,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  RoutePaginationEntity copyWith({
    List<RouteEntity>? routes,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPages,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return RoutePaginationEntity(
      routes: routes ?? this.routes,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  int get currentPage => pageNumber;

  bool get isLastPage => !hasNextPage;
}
