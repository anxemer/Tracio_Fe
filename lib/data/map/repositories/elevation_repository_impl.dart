import 'package:dartz/dartz.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:tracio_fe/data/map/source/elevation_api_service.dart';
import 'package:tracio_fe/domain/map/repositories/elevation_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class ElevationRepositoryImpl extends ElevationRepository {
  @override
  Future<Either<dynamic, List<ElevationPoint>>>
      postElevationFromPolylineEncoded(String encodedPolyline) async {
    var returnedData = await sl<ElevationApiService>()
        .postElevationFromPolyline(encodedPolyline);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }
}
