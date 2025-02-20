import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/map/models/mapbox_direction_req.dart';

abstract class RouteRepository {
  Future<Either> getRoutes();
  Future<Either> getDirectionUsingMapbox(MapboxDirectionsRequest request);
}
