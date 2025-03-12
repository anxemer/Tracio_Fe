import 'package:dartz/dartz.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/source/elevation_api_service.dart';
import 'package:tracio_fe/service_locator.dart';

class GetElevationUseCase extends Usecase<List<ElevationPoint>, String> {
  @override
  Future<Either<Failure, List<ElevationPoint>>> call(String params) async {
    return await sl<ElevationApiService>().postElevationFromPolyline(params);
  }
}
