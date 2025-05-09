import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/map/entities/route_detail.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetRouteDetailUsecase extends Usecase<dynamic, int> {
  @override
  Future<Either<Failure, RouteDetailEntity>> call(int params) async {
    return await sl<RouteRepository>().getRouteDetail(params);
  }
}
