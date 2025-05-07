import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class FinishTrackingUsecase extends Usecase<dynamic, Map<String, dynamic>> {
  @override
  Future<Either<Failure, dynamic>> call(Map<String, dynamic> params) async {
    return await sl<RouteRepository>().finishTracking(params);
  }
}
