class PostRouteReq {
  final String routeName;
  final String? routeDescription;
  final Location origin;
  final Location destination;
  final List<Location>? waypoints;
  final String polylineOverview;
  final String travelMode;
  final int weighting;
  final Location? avoid;
  final List<String>? avoidsRoads;
  final bool optimize;
  final String staticImage;
  final int privacy;

  PostRouteReq(
      {required this.routeName,
      this.routeDescription,
      required this.origin,
      required this.destination,
      this.waypoints,
      required this.polylineOverview,
      this.travelMode = "bike",
      this.weighting = 2,
      this.avoid,
      this.avoidsRoads,
      this.optimize = false,
      required this.staticImage,
      required this.privacy});

  factory PostRouteReq.fromJson(Map<String, dynamic> json) {
    return PostRouteReq(
        routeName: json['routeName'],
        routeDescription: json['description'],
        origin: Location.fromJson(json['origin']),
        destination: Location.fromJson(json['destination']),
        waypoints: (json['waypoints'] as List)
            .map((e) => Location.fromJson(e))
            .toList(),
        polylineOverview: json['polylineOverview'].toString(),
        travelMode: json['travelMode'] ?? "cycling",
        weighting: json['weighting'] ?? 2,
        avoid: json['avoid'] != null ? Location.fromJson(json['avoid']) : null,
        avoidsRoads:
            (json['avoidsRoads'] as List?)?.map((e) => e as String).toList(),
        optimize: json['optimize'] ?? false,
        staticImage: json['routeThumbnail'].toString(),
        privacy: json['privacyLevel'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      'routeName': routeName.trim(),
      'description': routeDescription != null ? routeDescription!.trim() : "",
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'waypoints': waypoints?.map((e) => e.toJson()).toList(),
      'polylineOverview': polylineOverview,
      'travelMode': travelMode,
      'weighting': weighting,
      'avoid': avoid?.toJson(),
      'avoidsRoads': avoidsRoads,
      'optimize': optimize,
      'routeThumbnail': staticImage,
      'privacyLevel': privacy
    };
  }
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
