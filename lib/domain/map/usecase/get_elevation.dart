import 'package:dartz/dartz.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/map/source/elevation_api_service.dart';
import 'package:Tracio/service_locator.dart';

class GetElevationUseCase extends Usecase<List<ElevationPoint>, String> {
  @override
  Future<Either<Failure, List<ElevationPoint>>> call(String params) async {
    return await sl<ElevationApiService>().postElevationFromPolyline(params);
  }
}
