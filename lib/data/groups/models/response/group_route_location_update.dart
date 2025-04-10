import 'package:tracio_fe/domain/groups/entities/group_route_location_update.dart';

class GroupRouteLocationUpdateModel extends GroupRouteLocationUpdateEntity {
  const GroupRouteLocationUpdateModel({
    required super.userId,
    required super.userName,
    required super.profilePicture,
    required super.latitude,
    required super.longitude,
    required super.timestamp,
  });

  factory GroupRouteLocationUpdateModel.fromMap(Map<String, dynamic> map) {
    return GroupRouteLocationUpdateModel(
      userId: map['userId'] as int,
      userName: map['userName'] as String,
      profilePicture: map['profilePicture'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      timestamp: map['timestamp'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'profilePicture': profilePicture,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    };
  }
}
