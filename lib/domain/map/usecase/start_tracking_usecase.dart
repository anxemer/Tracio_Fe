import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class StartTrackingUsecase extends Usecase<dynamic, Map<String, dynamic>> {
  @override
  Future<Either<Failure, dynamic>> call(Map<String, dynamic> params) async {
    return await sl<RouteRepository>().startTracking(params);
  }
}
