class RouteMediaEntity {
  int mediaId;
  String mediaUrl;
  Location? location;
  DateTime capturedAt;
  DateTime uploadedAt;
  RouteMediaEntity({
    required this.mediaId,
    required this.mediaUrl,
    this.location,
    required this.capturedAt,
    required this.uploadedAt,
  });
}

class Location {
  double longitude;
  double latitude;
  double altitude;
  Location({
    required this.longitude,
    required this.latitude,
    required this.altitude,
  });

  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(
      longitude: (map['longitude'] ?? 0).toDouble(),
      latitude: (map['latitude'] ?? 0).toDouble(),
      altitude: (map['altitude'] ?? 0).toDouble(),
    );
  }
}
