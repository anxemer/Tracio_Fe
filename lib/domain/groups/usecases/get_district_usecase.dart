import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/groups/models/response/vietnam_city_model.dart';
import 'package:tracio_fe/data/groups/source/vietnam_city_district_service.dart';
import 'package:tracio_fe/service_locator.dart';

class GetDistrictUsecase extends Usecase<VietnamCityModel, int?> {
  @override
  Future<Either<Failure, VietnamCityModel>> call(int? params) async {
    return await sl<VietnamCityDistrictService>().getDistrictsByCity(params!);
  }
}
