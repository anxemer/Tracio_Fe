import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/groups/models/response/vietnam_city_model.dart';
import 'package:tracio_fe/data/groups/source/vietnam_city_district_service.dart';
import 'package:tracio_fe/service_locator.dart';

class GetCityUsecase extends Usecase<List<VietnamCityModel>, NoParams> {
  @override
  Future<Either<Failure, List<VietnamCityModel>>> call(NoParams? params) async {
    return await sl<VietnamCityDistrictService>().getCities();
  }
}
