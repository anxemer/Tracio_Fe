import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/map/models/get_place_req.dart';

abstract class LocationRepository {
  Future<Either> getPlacesAutocomplete(GetPlaceReq request);
  Future<Either> getPlaceDetail(GetPlaceDetailReq request);
}
