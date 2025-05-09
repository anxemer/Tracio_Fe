class OpenElevationReq {
  final List<Location> locations;

  OpenElevationReq({required this.locations});
  Map<String, dynamic> toJson() {
    return {
      'locations': locations.map((loc) => loc.toJson()).toList(),
    };
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
