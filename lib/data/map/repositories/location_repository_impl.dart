import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/map/models/response/get_place_rep.dart';
import 'package:tracio_fe/data/map/models/request/get_place_req.dart';
import 'package:tracio_fe/data/map/source/location_api_service.dart';
import 'package:tracio_fe/domain/map/repositories/location_repository.dart';
import 'package:tracio_fe/service_locator.dart';

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
