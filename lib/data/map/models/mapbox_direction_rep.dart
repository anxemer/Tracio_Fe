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
    final route = (json['routes'] as List?)?.first;
    if (route == null) throw Exception('No routes found');

    final waypoints = (json['waypoints'] as List?)
            ?.map((w) => Position(w['location'][0], w['location'][1]))
            .toList() ??
        [];

    final geometryString = route['geometry'];
    final decodedPolyline = decodePolyline(geometryString)
        .map((coord) => Position(coord[1], coord[0]))
        .toList();
    final lineString = LineString(coordinates: decodedPolyline);

    final legs = (route['legs'] as List?)
            ?.map((legJson) => Leg.fromJson(legJson))
            .toList() ??
        [];

    return MapboxDirectionResponse(
      distance: (route['distance'] ?? 0).toDouble(),
      duration: (route['duration'] ?? 0).toDouble(),
      geometry: lineString,
      waypoints: waypoints,
      polyLineOverview: geometryString,
      legs: legs,
    );
  }

  Map<String, dynamic> toJson() => {
        'distance': distance,
        'duration': duration,
        'geometry': polyLineOverview,
        'waypoints': waypoints.map((w) => [w.lng, w.lat]).toList(),
        'legs': legs.map((leg) => leg.toJson()).toList(),
      };
}

class Leg {
  final double distance;
  final double duration;
  final List<Step> steps;

  Leg({required this.distance, required this.duration, required this.steps});

  factory Leg.fromJson(Map<String, dynamic> json) {
    return Leg(
      distance: (json['distance'] ?? 0).toDouble(),
      duration: (json['duration'] ?? 0).toDouble(),
      steps: (json['steps'] as List?)
              ?.map((stepJson) => Step.fromJson(stepJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'distance': distance,
        'duration': duration,
        'steps': steps.map((step) => step.toJson()).toList(),
      };
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
    final decodedPolyline = decodePolyline(geometryString)
        .map((coord) => Position(coord[1], coord[0]))
        .toList();
    final lineString = LineString(coordinates: decodedPolyline);

    return Step(
      instruction: json['maneuver']['instruction'] ?? '',
      distance: (json['distance'] ?? 0).toDouble(),
      duration: (json['duration'] ?? 0).toDouble(),
      geometry: lineString,
    );
  }

  Map<String, dynamic> toJson() => {
        'instruction': instruction,
        'distance': distance,
        'duration': duration,
        'geometry': geometry?.coordinates.map((p) => [p.lng, p.lat]).toList(),
      };
}
