import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/map/models/response/get_place_rep.dart';
import 'package:Tracio/data/map/models/request/get_place_req.dart';
import 'package:Tracio/data/map/source/location_api_service.dart';
import 'package:Tracio/domain/map/repositories/location_repository.dart';
import 'package:Tracio/service_locator.dart';

class LocationRepositoryImpl extends LocationRepository {
  @override
  Future<Either<Failure, GetPlacesRep>> getPlacesAutocomplete(
      GetPlaceReq request) async {
    var returnedData =
        await sl<LocationApiService>().getPlacesAutocomplete(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, GetPlaceDetailRep>> getPlaceDetail(
      GetPlaceDetailReq request) async {
    var returnedData = await sl<LocationApiService>().getPlaceDetail(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }
}
