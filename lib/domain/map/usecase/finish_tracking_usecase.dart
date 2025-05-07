import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/map/models/request/finish_tracking_req.dart';
import 'package:Tracio/domain/map/entities/route_detail.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class FinishTrackingUsecase extends Usecase<dynamic, FinishTrackingReq> {
  @override
  Future<Either<Failure, RouteDetailEntity>> call(
      FinishTrackingReq params) async {
    return await sl<RouteRepository>().finishTracking(params);
  }
}
