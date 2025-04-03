import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/models/response/mapbox_direction_rep.dart';
import 'package:tracio_fe/data/map/models/request/mapbox_direction_req.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetDirectionUsingMapboxUseCase
    extends Usecase<MapboxDirectionResponse, MapboxDirectionsRequest> {
  @override
  Future<Either<Failure, MapboxDirectionResponse>> call(
      MapboxDirectionsRequest params) async {
    return await sl<RouteRepository>().getDirectionUsingMapbox(params);
  }
}
