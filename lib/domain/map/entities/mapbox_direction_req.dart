class MapboxDirectionsRequestEntity {
  final String profile;
  final List<Coordinate> coordinates;
  final String accessToken;
  final bool alternatives;
  final String annotations;
  final bool continueStraight;
  final String geometries;
  final String language;
  final String overview;
  final bool steps;
  final bool bannerInstructions;

  MapboxDirectionsRequestEntity(
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

  Map<String, String> toMap() {
    return {
      'alternatives': alternatives.toString(),
      'annotations': annotations,
      'continue_straight': continueStraight.toString(),
      'geometries': geometries,
      'language': language,
      'overview': overview,
      'steps': steps.toString(),
      'access_token': accessToken,
      "banner_instructions": bannerInstructions.toString(),
    };
  }

  /// Special: Build coordinates string for URL
  String coordinatesToString() {
    return coordinates.map((c) => '${c.longitude},${c.latitude}').join(';');
  }
}

class Coordinate {
  final double longitude;
  final double latitude;

  Coordinate(this.longitude, this.latitude);
}
