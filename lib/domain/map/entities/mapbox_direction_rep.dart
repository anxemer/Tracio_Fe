import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxDirectionResponseEntity {
  final double distance;
  final double duration;
  final LineString? geometry;
  final String? polyLineOverview;
  final List<LegEntity> legs;

  MapboxDirectionResponseEntity({
    required this.distance,
    required this.duration,
    this.geometry,
    this.polyLineOverview,
    required this.legs,
  });
}

class LegEntity {
  final double distance;
  final double duration;
  final List<StepEntity> steps;

  LegEntity({
    required this.distance,
    required this.duration,
    required this.steps,
  });
}

class StepEntity {
  final String instruction;
  final double distance;
  final double duration;
  final LineString? geometry;

  StepEntity({
    required this.instruction,
    required this.distance,
    required this.duration,
    this.geometry,
  });
}
