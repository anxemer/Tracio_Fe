import 'package:tracio_fe/data/map/models/mapbox_direction_rep.dart';

abstract class GetDirectionState {}

class GetDirectionWaiting extends GetDirectionState {}
class GetDirectionLoading extends GetDirectionState {}

class GetDirectionLoaded extends GetDirectionState {
  final MapboxDirectionResponse direction;

  GetDirectionLoaded({required this.direction});
}

class GetDirectionFailure extends GetDirectionState {
  final String errorMessage;

  GetDirectionFailure({required this.errorMessage});
}
