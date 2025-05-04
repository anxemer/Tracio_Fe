import 'dart:convert';

class PostRouteReq {
  final String routeName;
  final String? description;
  final Location origin;
  final Location destination;
  final List<Location>? waypoints;
  final String polyline;
  final String routeThumbnail;
  final String privacyLevel;
  PostRouteReq({
    required this.routeName,
    this.description,
    required this.origin,
    required this.destination,
    this.waypoints,
    required this.polyline,
    required this.routeThumbnail,
    this.privacyLevel = 'Public',
  });

  PostRouteReq copyWith({
    String? routeName,
    String? description,
    Location? origin,
    Location? destination,
    List<Location>? waypoints,
    String? polyline,
    String? routeThumbnail,
    String? privacyLevel,
  }) {
    return PostRouteReq(
      routeName: routeName ?? this.routeName,
      description: description ?? this.description,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      waypoints: waypoints ?? this.waypoints,
      polyline: polyline ?? this.polyline,
      routeThumbnail: routeThumbnail ?? this.routeThumbnail,
      privacyLevel: privacyLevel ?? this.privacyLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routeName': routeName,
      'description': description,
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'waypoints': waypoints?.map((x) => x.toJson()).toList() ?? [],
      'polyline': polyline,
      'routeThumbnail': routeThumbnail,
      'privacyLevel': privacyLevel,
    };
  }

  String toJson() => json.encode(toMap());
}

class Location {
  final double latitude;
  final double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
