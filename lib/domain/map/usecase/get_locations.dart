import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/models/reponse/get_place_rep.dart';
import 'package:tracio_fe/data/map/models/request/get_place_req.dart';
import 'package:tracio_fe/domain/map/repositories/location_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetLocationAutoCompleteUseCase
    extends Usecase<GetPlacesRep, GetPlaceReq> {
  @override
  Future<Either<Failure, GetPlacesRep>> call(GetPlaceReq params) async {
    return await sl<LocationRepository>().getPlacesAutocomplete(params);
  }
}
