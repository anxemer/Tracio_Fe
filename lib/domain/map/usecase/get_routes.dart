import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/map/models/response/get_route_rep.dart';
import 'package:Tracio/data/map/models/request/get_route_req.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetRoutesUseCase extends Usecase<dynamic, GetRouteReq> {
  @override
  Future<Either<Failure, GetRouteRepModel>> call(GetRouteReq params) async {
    return await sl<RouteRepository>().getRoutes(params);
  }
}
