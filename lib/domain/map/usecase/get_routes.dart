import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/models/reponse/get_route_rep.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetRoutesUseCase extends Usecase<dynamic, GetRouteReq> {
  @override
  Future<Either<Failure, GetRouteRepModel>> call(GetRouteReq params) async {
    return await sl<RouteRepository>().getRoutes(params);
  }
}
