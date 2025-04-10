import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class GroupRouteLocationUpdateEntity {
  final int userId;
  final String userName;
  final String profilePicture;
  final double latitude;
  final double longitude;
  final int timestamp;

  const GroupRouteLocationUpdateEntity({
    required this.userId,
    required this.userName,
    required this.profilePicture,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Position get position => Position(longitude, latitude);

  DateTime get dateTime =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}
