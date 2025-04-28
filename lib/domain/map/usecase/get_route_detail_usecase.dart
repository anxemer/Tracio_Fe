import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/map/entities/route_detail.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetRouteDetailUsecase extends Usecase<dynamic, int> {
  @override
  Future<Either<Failure, RouteDetailEntity>> call(int params) async {
    return await sl<RouteRepository>().getRouteDetail(params);
  }
}
