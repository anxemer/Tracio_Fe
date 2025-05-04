import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxDirectionResponseEntity {
  final double distance;
  final double duration;
  final LineString? geometry;
  final List<Position> waypoints;
  final String? polylineOverview;
  final List<LegsEntity> legs;

  MapboxDirectionResponseEntity({
    required this.distance,
    required this.duration,
    required this.waypoints,
    this.geometry,
    this.polylineOverview,
    required this.legs,
  });

  factory MapboxDirectionResponseEntity.fromMap(Map<String, dynamic> map) {
    final routes = (map['routes'] as List<dynamic>?) ?? [];
    final firstRoute =
        routes.isNotEmpty ? routes[0] as Map<String, dynamic> : {};
    final geometryString = firstRoute['geometry'];
    final decodedPolyline = decodePolyline(geometryString)
        .map((coord) => Position(coord[1], coord[0]))
        .toList();
    final waypointsList = (map['waypoints'] as List<dynamic>? ?? []);

    final lineString = LineString(coordinates: decodedPolyline);
    return MapboxDirectionResponseEntity(
      waypoints: waypointsList.map((e) {
        final location = (e['location'] as List<dynamic>? ?? []);
        if (location.length >= 2) {
          return Position(location[0].toDouble(), location[1].toDouble());
        } else {
          throw Exception('Invalid waypoint location format');
        }
      }).toList(),
      distance: (firstRoute['distance'] ?? 0).toDouble(),
      duration: (firstRoute['duration'] ?? 0).toDouble(),
      geometry: firstRoute['geometry'] != null ? lineString : null,
      polylineOverview: firstRoute['geometry'],
      legs: (firstRoute['legs'] as List<dynamic>?)
              ?.map((e) => LegsEntity.fromMap(e))
              .toList() ??
          [],
    );
  }
}

class LegsEntity {
  final double distance;
  final double duration;
  final String? summary;
  final List<StepEntity> steps;

  LegsEntity({
    required this.distance,
    required this.duration,
    this.summary,
    required this.steps,
  });

  factory LegsEntity.fromMap(Map<String, dynamic> map) {
    return LegsEntity(
      distance: (map['distance'] ?? 0).toDouble(),
      duration: (map['duration'] ?? 0).toDouble(),
      summary: map['summary'],
      steps: (map['steps'] as List<dynamic>?)
              ?.map((e) => StepEntity.fromMap(e))
              .toList() ??
          [],
    );
  }
}

class StepEntity {
  final List<BannerInstructionEntity> bannerInstructions;
  final ManeuverEntity maneuver;
  final double distance;
  final double duration;
  final String polylineOverview;
  final String name;

  StepEntity({
    required this.bannerInstructions,
    required this.maneuver,
    required this.distance,
    required this.duration,
    required this.polylineOverview,
    required this.name,
  });

  factory StepEntity.fromMap(Map<String, dynamic> map) {
    return StepEntity(
      bannerInstructions: (map['bannerInstructions'] as List<dynamic>?)
              ?.map((e) =>
                  BannerInstructionEntity.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
      maneuver: ManeuverEntity.fromMap(map['maneuver']),
      distance: (map['distance'] ?? 0).toDouble(),
      duration: (map['duration'] ?? 0).toDouble(),
      polylineOverview: map['geometry'] ?? '',
      name: map['name'] ?? '',
    );
  }
}

class BannerInstructionEntity {
  num distanceAlongGeometry;
  BannerTypeEntity primary;
  BannerTypeEntity? secondary;
  BannerTypeEntity? sub;

  BannerInstructionEntity({
    required this.distanceAlongGeometry,
    required this.primary,
    this.secondary,
    this.sub,
  });

  factory BannerInstructionEntity.fromMap(Map<String, dynamic> map) {
    return BannerInstructionEntity(
      distanceAlongGeometry: map['distanceAlongGeometry'] ?? 0,
      primary: BannerTypeEntity.fromMap(map['primary']),
      secondary: map['secondary'] != null
          ? BannerTypeEntity.fromMap(map['secondary'])
          : null,
      sub: map['sub'] != null ? BannerTypeEntity.fromMap(map['sub']) : null,
    );
  }
}

class BannerTypeEntity {
  String text;
  String type;
  String modifier;
  int degrees;
  String drivingSide;
  List<BannerComponentEntity> components;

  BannerTypeEntity({
    required this.text,
    required this.type,
    required this.modifier,
    required this.degrees,
    required this.drivingSide,
    required this.components,
  });

  factory BannerTypeEntity.fromMap(Map<String, dynamic> map) {
    return BannerTypeEntity(
      text: map['text'] ?? '',
      type: map['type'] ?? '',
      modifier: map['modifier'] ?? '',
      degrees: (map['degrees'] ?? 0).toInt(),
      drivingSide: map['driving_side'] ?? '',
      components: (map['components'] as List<dynamic>?)
              ?.map((e) => BannerComponentEntity.fromMap(e))
              .toList() ??
          [],
    );
  }
}

class BannerComponentEntity {
  String type;
  String text;

  BannerComponentEntity({
    required this.type,
    required this.text,
  });

  factory BannerComponentEntity.fromMap(Map<String, dynamic> map) {
    return BannerComponentEntity(
      type: map['type'] ?? '',
      text: map['text'] ?? '',
    );
  }
}

class ManeuverEntity {
  int bearingBefore;
  int bearingAfter;
  String instruction;
  Position location;
  String modifier;
  ManeuverTypesEnum type;

  ManeuverEntity({
    required this.bearingBefore,
    required this.bearingAfter,
    required this.instruction,
    required this.location,
    required this.modifier,
    required this.type,
  });

  factory ManeuverEntity.fromMap(Map<String, dynamic> map) {
    return ManeuverEntity(
      bearingBefore: (map['bearing_before'] ?? 0).toInt(),
      bearingAfter: (map['bearing_after'] ?? 0).toInt(),
      instruction: map['instruction'] ?? '',
      location: Position(
          map['location'][0].toDouble(), map['location'][1].toDouble()),
      modifier: map['modifier'] ?? '',
      type: ManeuverTypesEnum.values.firstWhere(
        (e) => e.name.toLowerCase() == (map['type'] ?? '').toLowerCase(),
        orElse: () => ManeuverTypesEnum.turn,
      ),
    );
  }
}

enum ManeuverTypesEnum {
  turn,
  newName,
  depart,
  arrive,
  merge,
  onRamp,
  offRamp,
  fork,
  endOfRoad,
  continues,
  roundabout,
  rotary,
  roundaboutTurn,
  notification,
  exitRoundabout,
  exitRotary
}
