import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/map/models/response/get_place_rep.dart';
import 'package:Tracio/data/map/models/request/get_place_req.dart';
import 'package:Tracio/domain/map/repositories/location_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetLocationDetailUseCase extends Usecase<GetPlaceDetailRep, GetPlaceDetailReq> {
  @override
  Future<Either<Failure, GetPlaceDetailRep>> call(GetPlaceDetailReq params) async {
    return await sl<LocationRepository>().getPlaceDetail(params);
  }
}