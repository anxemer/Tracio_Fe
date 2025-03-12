import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/models/post_route_req.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class PostRouteUseCase extends Usecase<dynamic, PostRouteReq> {
  @override
  Future<Either<Failure, dynamic>> call(PostRouteReq params) async {
    return await sl<RouteRepository>().postRoute(params);
  }
}
