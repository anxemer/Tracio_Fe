import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/models/response/get_place_rep.dart';
import 'package:tracio_fe/data/map/models/request/get_place_req.dart';
import 'package:tracio_fe/domain/map/repositories/location_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetLocationDetailUseCase extends Usecase<GetPlaceDetailRep, GetPlaceDetailReq> {
  @override
  Future<Either<Failure, GetPlaceDetailRep>> call(GetPlaceDetailReq params) async {
    return await sl<LocationRepository>().getPlaceDetail(params);
  }
}