import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/groups/models/response/vietnam_city_model.dart';
import 'package:Tracio/data/groups/source/vietnam_city_district_service.dart';
import 'package:Tracio/service_locator.dart';

class GetCityUsecase extends Usecase<List<VietnamCityModel>, NoParams> {
  @override
  Future<Either<Failure, List<VietnamCityModel>>> call(NoParams? params) async {
    return await sl<VietnamCityDistrictService>().getCities();
  }
}
