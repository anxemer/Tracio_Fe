import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/map/models/reponse/get_route_rep.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/data/map/models/reponse/mapbox_direction_rep.dart';
import 'package:tracio_fe/data/map/models/request/mapbox_direction_req.dart';
import 'package:tracio_fe/data/map/models/request/post_route_req.dart';
import 'package:tracio_fe/data/map/source/route_api_service.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class RouteRepositoryImpl extends RouteRepository {
  @override
  Future<Either<Failure, MapboxDirectionResponse>> getDirectionUsingMapbox(
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
  Future<Either<Failure, GetRouteRepModel>> getRoutes(GetRouteReq request) async {
    var returnedData = await sl<RouteApiService>().getRoutes(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> postRoute(PostRouteReq request) async {
    var returnedData = await sl<RouteApiService>().postRoute(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }
}
