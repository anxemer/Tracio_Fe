class MapboxDirectionsRequest {
  final String profile; // e.g., "mapbox/cycling"
  final List<Coordinate> coordinates; // List of coordinates
  final String accessToken; // Your Mapbox access token
  final bool alternatives; // Include alternative routes
  final String annotations; // Annotations for distance, duration, etc.
  final bool continueStraight; // Continue straight option
  final String geometries; // Geometry format (e.g., "polyline")
  final String language; // Language for instructions
  final String overview; // Overview type (e.g., "full")
  final bool steps; // Include turn-by-turn instructions
  final bool bannerInstructions;

  MapboxDirectionsRequest(
      {required this.profile,
      required this.coordinates,
      required this.accessToken,
      this.alternatives = true,
      this.annotations = 'distance,duration,speed',
      this.continueStraight = true,
      this.geometries = 'polyline',
      this.language = 'en',
      this.overview = 'full',
      this.steps = true,
      this.bannerInstructions = true});

  Uri toUri() {
    final coordsString =
        coordinates.map((c) => '${c.longitude},${c.latitude}').join(';');

    return Uri.https(
      'api.mapbox.com',
      '/directions/v5/mapbox/$profile/$coordsString',
      {
        'alternatives': alternatives.toString(),
        'annotations': annotations,
        'continue_straight': continueStraight.toString(),
        'geometries': geometries,
        'language': language,
        'overview': overview,
        'steps': steps.toString(),
        'access_token': accessToken,
        'banner_instructions': bannerInstructions.toString()
      },
    );
  }
}

class Coordinate {
  final double longitude;
  final double latitude;

  Coordinate(this.longitude, this.latitude);

  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
    };
  }

  factory Coordinate.fromJson(Map<String, dynamic> json) {
    return Coordinate(json['longitude'], json['latitude']);
  }
}
