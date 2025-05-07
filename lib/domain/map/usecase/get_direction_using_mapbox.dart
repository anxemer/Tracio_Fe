import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/map/models/request/mapbox_direction_req.dart';
import 'package:Tracio/domain/map/entities/mapbox_direction_rep.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetDirectionUsingMapboxUseCase
    extends Usecase<MapboxDirectionResponseEntity, MapboxDirectionsRequest> {
  @override
  Future<Either<Failure, MapboxDirectionResponseEntity>> call(
      MapboxDirectionsRequest params) async {
    return await sl<RouteRepository>().getDirectionUsingMapbox(params);
  }
}
