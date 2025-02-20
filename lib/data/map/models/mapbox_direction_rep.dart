import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxDirectionResponse {
  final double distance;
  final double duration;
  final LineString? geometry;
  final List<Position> waypoints;
  final String? polyLineOverview;
  final List<Leg> legs;

  MapboxDirectionResponse({
    required this.distance,
    required this.duration,
    required this.waypoints,
    this.geometry,
    this.polyLineOverview,
    required this.legs,
  });

  factory MapboxDirectionResponse.fromJson(Map<String, dynamic> json) {
    // Route
    final routes = json['routes'];
    if (routes == null || routes.isEmpty) {
      throw Exception('No routes found in the response');
    }
    final route = routes[0];

    // Extract Waypoints
    List<Position> waypointsList = [];
    final waypointsJson = json['waypoints'];
    if (waypointsJson != null && waypointsJson is List) {
      waypointsList = waypointsJson.map((waypoint) {
        double longitude = waypoint['location'][0];
        double latitude = waypoint['location'][1];
        return Position(longitude, latitude);
      }).toList();
    }

    // Geometry
    final geometryString = route['geometry'];
    List<List<num>> decodedPolyline = decodePolyline(geometryString).toList();
    List<Position> positions = decodedPolyline
        .map((coord) => Position(coord[1], coord[0]))
        .toList();
    final LineString lineString = LineString(coordinates: positions);

    // Legs
    final List<dynamic> legsJson = route['legs'];
    final List<Leg> legs =
        legsJson.map((legJson) => Leg.fromJson(legJson)).toList();

    return MapboxDirectionResponse(
      distance: route['distance']?.toDouble() ?? 0.0,
      duration: route['duration']?.toDouble() ?? 0.0,
      geometry: lineString,
      waypoints: waypointsList, // Assign the parsed waypoints
      polyLineOverview: geometryString,
      legs: legs,
    );
  }
}

class Leg {
  final double distance;
  final double duration;
  final List<Step> steps;

  Leg({
    required this.distance,
    required this.duration,
    required this.steps,
  });

  factory Leg.fromJson(Map<String, dynamic> json) {
    final List<dynamic> stepsJson = json['steps'];
    final List<Step> steps =
        stepsJson.map((stepJson) => Step.fromJson(stepJson)).toList();

    return Leg(
      distance: json['distance']?.toDouble() ?? 0.0,
      duration: json['duration']?.toDouble() ?? 0.0,
      steps: steps,
    );
  }
}

class Step {
  final String instruction;
  final double distance;
  final double duration;
  final LineString? geometry;

  Step({
    required this.instruction,
    required this.distance,
    required this.duration,
    this.geometry,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    final geometryString = json['geometry'];
    List<List<num>> decodedPolyline = decodePolyline(geometryString).toList();
    List<Position> positions = decodedPolyline
        .map((coord) => Position(coord[1], coord[0]))
        .toList();
    final LineString lineString = LineString(coordinates: positions);

    return Step(
      instruction: json['maneuver']['instruction'] ?? '',
      distance: json['distance']?.toDouble() ?? 0.0,
      duration: json['duration']?.toDouble() ?? 0.0,
      geometry: lineString,
    );
  }
}
