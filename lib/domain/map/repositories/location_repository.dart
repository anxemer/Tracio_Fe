import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/map/models/get_place_rep.dart';
import 'package:tracio_fe/data/map/models/get_place_req.dart';

abstract class LocationRepository {
  Future<Either<Failure, GetPlacesRep>> getPlacesAutocomplete(
      GetPlaceReq request);
  Future<Either<Failure, GetPlaceDetailRep>> getPlaceDetail(
      GetPlaceDetailReq request);
}
