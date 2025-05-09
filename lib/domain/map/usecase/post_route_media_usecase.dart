import 'package:Tracio/data/map/models/request/post_route_media_req.dart';
import 'package:Tracio/domain/map/entities/route_media.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class PostRouteMediaUsecase extends Usecase<dynamic, PostRouteMediaReq> {
  @override
  Future<Either<Failure, RouteMediaEntity>> call(params) async {
    return await sl<RouteRepository>().postRouteMediaFiles(params);
  }
}
