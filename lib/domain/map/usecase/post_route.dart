import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/map/models/request/post_route_req.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class PostRouteUseCase extends Usecase<dynamic, PostRouteReq> {
  @override
  Future<Either<Failure, dynamic>> call(PostRouteReq params) async {
    return await sl<RouteRepository>().postRoute(params);
  }
}
