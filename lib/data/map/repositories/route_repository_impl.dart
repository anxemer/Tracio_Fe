import 'package:dartz/dartz.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:tracio_fe/data/map/models/mapbox_direction_rep.dart';
import 'package:tracio_fe/data/map/models/mapbox_direction_req.dart';
import 'package:tracio_fe/data/map/source/elevation_api_service.dart';
import 'package:tracio_fe/data/map/source/route_api_service.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class RouteRepositoryImpl extends RouteRepository {
  @override
  Future<Either> getDirectionUsingMapbox(
      MapboxDirectionsRequest request) async {
    var returnedData = await sl<RouteApiService>().getRouteUsingMapBox(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      final direction = MapboxDirectionResponse.fromJson(data);
      return right(direction);
    });
  }

  @override
  Future<Either> getRoutes() {
    // TODO: implement getRoutes
    throw UnimplementedError();
  }
}
