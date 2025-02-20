import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

abstract class MapCubitState {}

class MapCubitInitial extends MapCubitState {}

class MapCubitRouteLoading extends MapCubitState {}

class MapCubitRouteLoaded extends MapCubitState {
  final LineString lineString;

  MapCubitRouteLoaded({required this.lineString});
}

class MapCubitStyleLoaded extends MapCubitState {
  final String styleUri;

  MapCubitStyleLoaded({required this.styleUri});
}

class MapAnnotationsUpdated extends MapCubitState {
  final List<PointAnnotationOptions> annotations;

  MapAnnotationsUpdated({required this.annotations});
}
