import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/source/elevation_api_service.dart';
import 'package:tracio_fe/service_locator.dart';

class GetElevationUseCase extends Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<ElevationApiService>().postElevationFromPolyline(params);
  }
}
