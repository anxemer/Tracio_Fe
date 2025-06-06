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
  MapAnnotationsUpdated();
}

class StaticImageLoading extends MapCubitState {}

class StaticImageLoaded extends MapCubitState {
  final Uri? snapshot;

  StaticImageLoaded({this.snapshot});
}

class StaticImageFailure extends MapCubitState {
  final String errorMessage;
  StaticImageFailure({required this.errorMessage});
}
