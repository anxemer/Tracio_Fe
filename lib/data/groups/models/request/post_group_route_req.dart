import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class PostGroupRouteReq {
  int routeId;
  String title;
  String description;
  String addressMeeting;
  DateTime startTime;
  Position address;

  PostGroupRouteReq({
    required this.routeId,
    required this.title,
    required this.description,
    required this.addressMeeting,
    required this.startTime,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'routeId': routeId,
      'title': title,
      'description': description,
      'addressMeeting': addressMeeting,
      'startTime': startTime.toIso8601String(), // ✅ ISO format
      'address': address.toMap(), // ✅ use new extension
    };
  }

  factory PostGroupRouteReq.fromMap(Map<String, dynamic> map) {
    return PostGroupRouteReq(
      routeId: map['routeId'],
      title: map['title'],
      description: map['description'],
      addressMeeting: map['addressMeeting'],
      startTime: DateTime.parse(map['startTime']), // ✅ parse ISO format
      address: PositionMapper.fromMap(map['address']),
    );
  }

  @override
  String toString() {
    return 'PostGroupRouteReq(routeId: $routeId, title: $title, description: $description, addressMeeting: $addressMeeting, startTime: $startTime, address: $address)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostGroupRouteReq &&
          runtimeType == other.runtimeType &&
          routeId == other.routeId &&
          title == other.title &&
          description == other.description &&
          addressMeeting == other.addressMeeting &&
          startTime == other.startTime &&
          address == other.address;

  @override
  int get hashCode =>
      routeId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      addressMeeting.hashCode ^
      startTime.hashCode ^
      address.hashCode;
}

extension PositionMapper on Position {
  Map<String, dynamic> toMap() {
    return {
      'latitude': lat,
      'longitude': lng,
      if (alt != null) 'altitude': alt,
    };
  }

  static Position fromMap(Map<String, dynamic> map) {
    return Position.named(
      lat: map['latitude'],
      lng: map['longitude'],
      alt: map.containsKey('altitude') ? map['altitude'] : null,
    );
  }
}
