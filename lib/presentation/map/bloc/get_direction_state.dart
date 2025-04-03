import 'package:map_elevation/map_elevation.dart';
import 'package:tracio_fe/data/map/models/response/mapbox_direction_rep.dart';

abstract class GetDirectionState {}

class GetDirectionWaiting extends GetDirectionState {}

class GetDirectionLoading extends GetDirectionState {}

class GetDirectionLoaded extends GetDirectionState {
  final MapboxDirectionResponse direction;
  final List<ElevationPoint>? elevationPoints;

  GetDirectionLoaded({required this.direction, this.elevationPoints});
}

class GetDirectionFailure extends GetDirectionState {
  final String errorMessage;

  GetDirectionFailure({required this.errorMessage});
}
class GetElevationLoading extends GetDirectionState {}

class GetElevationLoaded extends GetDirectionState {
  final List<ElevationPoint>? elevationPoints;

  GetElevationLoaded({this.elevationPoints});
}

class GetElevationFailure extends GetDirectionState {
  final String errorMessage;

  GetElevationFailure({required this.errorMessage});
}
