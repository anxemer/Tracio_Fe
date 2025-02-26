import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/map/models/get_place_rep.dart';
import 'package:tracio_fe/data/map/models/get_place_req.dart';
import 'package:tracio_fe/data/map/source/location_api_service.dart';
import 'package:tracio_fe/domain/map/repositories/location_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class LocationRepositoryImpl extends LocationRepository {
  @override
  Future<Either> getPlacesAutocomplete(GetPlaceReq request) async {
    var returnedData =
        await sl<LocationApiService>().getPlacesAutocomplete(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      final direction = GetPlacesRep.fromJson(data).toEntity();
      return right(direction);
    });
  }

  @override
  Future<Either> getPlaceDetail(GetPlaceDetailReq request) async {
    var returnedData = await sl<LocationApiService>().getPlaceDetail(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      final direction = GetPlaceDetailRep.fromJson(data).toEntity();
      return right(direction);
    });
  }
}
