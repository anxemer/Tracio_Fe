import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/map/models/response/get_route_rep.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/data/map/models/response/mapbox_direction_rep.dart';
import 'package:tracio_fe/data/map/models/request/mapbox_direction_req.dart';
import 'package:tracio_fe/data/map/models/request/post_route_req.dart';

abstract class RouteRepository {
  Future<Either<Failure, GetRouteRepModel>> getRoutes(GetRouteReq request);
  Future<Either<Failure, MapboxDirectionResponse>> getDirectionUsingMapbox(
      MapboxDirectionsRequest request);
  Future<Either<Failure, dynamic>> postRoute(PostRouteReq request);
}
