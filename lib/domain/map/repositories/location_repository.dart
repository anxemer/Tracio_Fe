import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/map/models/response/get_place_rep.dart';
import 'package:Tracio/data/map/models/request/get_place_req.dart';

abstract class LocationRepository {
  Future<Either<Failure, GetPlacesRep>> getPlacesAutocomplete(
      GetPlaceReq request);
  Future<Either<Failure, GetPlaceDetailRep>> getPlaceDetail(
      GetPlaceDetailReq request);
}
