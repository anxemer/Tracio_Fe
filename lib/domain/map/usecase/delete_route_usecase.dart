import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class DeleteRouteUsecase extends Usecase<dynamic, int> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<RouteRepository>().deleteRoute(params);
  }
}
