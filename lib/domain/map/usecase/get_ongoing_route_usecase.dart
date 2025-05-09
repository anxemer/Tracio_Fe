import 'package:Tracio/domain/map/entities/route.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetOngoingRouteUsecase extends Usecase<dynamic, NoParams> {
  @override
  Future<Either<Failure, RouteEntity>> call(params) async {
    return await sl<RouteRepository>().getOnGoingInRoute();
  }
}
