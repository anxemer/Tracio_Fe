// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Tracio/data/map/models/route.dart';

class RouteBlogEntity {
  int routeId;
  int cyclistId;
  String cyclistName;
  String cyclistAvatar;
  String routeName;
  String routeThumbnail;
  String? description;
  String? city;
  double totalDistance;
  double totalElevationGain;
  int totalDuration;
  double avgSpeed;
  int? mood;
  bool isPublic;
  bool isPlanned;
  bool isReacted;
  DateTime createdAt;
  DateTime updatedAt;
  RouteBlogEntity({
    required this.routeId,
    required this.cyclistId,
    required this.cyclistName,
    required this.cyclistAvatar,
    required this.routeName,
    required this.routeThumbnail,
    required this.description,
    required this.city,
    required this.totalDistance,
    required this.totalElevationGain,
    required this.totalDuration,
    required this.avgSpeed,
    required this.mood,
    required this.isPublic,
    required this.isPlanned,
    required this.isReacted,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedTotalDistance {
    return totalDistance.toStringAsFixed(2);
  }

  String get formattedTotalElevGain {
    return totalElevationGain.toStringAsFixed(2);
  }

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

  RouteBlogEntity copyWith({
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
    double? totalDistance,
    double? totalElevationGain,
    int? totalDuration,
    double? avgSpeed,
    int? mood,
    int? reactionCount,
    int? reviewCount,
    int? mediaFileCount,
    int? challengeCompletedCount,
    bool? isPublic,
    bool? isPlanned,
    bool? isReacted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RouteBlogEntity(
      routeId: routeId ?? this.routeId,
      cyclistId: cyclistId ?? this.cyclistId,
      cyclistName: cyclistName ?? this.cyclistName,
      cyclistAvatar: cyclistAvatar ?? this.cyclistAvatar,
      routeName: routeName ?? this.routeName,
      routeThumbnail: routeThumbnail ?? this.routeThumbnail,
      description: description ?? this.description,
      city: city ?? this.city,
      totalDistance: totalDistance ?? this.totalDistance,
      totalElevationGain: totalElevationGain ?? this.totalElevationGain,
      totalDuration: totalDuration ?? this.totalDuration,
      avgSpeed: avgSpeed ?? this.avgSpeed,
      mood: mood ?? this.mood,
      isPublic: isPublic ?? this.isPublic,
      isPlanned: isPlanned ?? this.isPlanned,
      createdAt: createdAt ?? this.createdAt,
      isReacted: isReacted ?? this.isReacted,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
