import 'package:tracio_fe/data/map/models/mapbox_direction_req.dart';

class MapboxDirectionsRequestEntity {
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

  MapboxDirectionsRequestEntity({
    required this.profile,
    required this.coordinates,
    required this.accessToken,
    this.alternatives = true,
    this.annotations = 'distance,duration,speed',
    this.continueStraight = true,
    this.geometries = 'polyline',
    this.language = 'en',
    this.overview = 'full',
    this.steps = true,
  });
}
