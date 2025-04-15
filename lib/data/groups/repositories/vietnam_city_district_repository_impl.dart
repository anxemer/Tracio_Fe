import 'package:dartz/dartz.dart';
import 'package:tracio_fe/data/groups/models/response/vietnam_city_model.dart';
import 'package:tracio_fe/data/groups/source/vietnam_city_district_service.dart';
import 'package:tracio_fe/domain/groups/repositories/vietnam_city_district_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class VietnamCityDistrictRepositoryImpl
    implements VietnamCityDistrictRepository {
  @override
  Future<Either<dynamic, List<VietnamCityModel>>> getCities() async {
    var returnedData = await sl<VietnamCityDistrictService>().getCities();
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<dynamic, VietnamCityModel>> getDistrictsByCity(
      int cityCode) async {
    var returnedData =
        await sl<VietnamCityDistrictService>().getDistrictsByCity(cityCode);
    return returnedData.fold((error) {  
      return left(error);
    }, (data) {
      return right(data);
    });
  }
}
