import 'package:Tracio/domain/map/entities/place.dart';

abstract class GetLocationState {}

class GetLocationInitial extends GetLocationState {}

class GetLocationsAutoCompleteLoading extends GetLocationState {}

class GetLocationsAutoCompleteLoaded extends GetLocationState {
  final List<PlaceEntity> places;
  GetLocationsAutoCompleteLoaded({required this.places});
}

class GetLocationsAutoCompleteFailure extends GetLocationState {
  final String errorMessage;

  GetLocationsAutoCompleteFailure({required this.errorMessage});
}

class GetLocationDetailLoading extends GetLocationState {}

class GetLocationDetailLoaded extends GetLocationState {
  final PlaceDetailEntity placeDetail;
  GetLocationDetailLoaded({required this.placeDetail});
}

class GetLocationDetailFailure extends GetLocationState {
  final String errorMessage;

  GetLocationDetailFailure({required this.errorMessage});
}
