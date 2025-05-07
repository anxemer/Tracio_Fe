import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/models/request/finish_tracking_req.dart';
import 'package:tracio_fe/domain/map/entities/route_detail.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class FinishTrackingUsecase extends Usecase<dynamic, FinishTrackingReq> {
  @override
  Future<Either<Failure, RouteDetailEntity>> call(
      FinishTrackingReq params) async {
    return await sl<RouteRepository>().finishTracking(params);
  }
}
