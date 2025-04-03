import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/groups/models/response/vietnam_city_model.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class VietnamCityDistrictService {
  Future<Either<Failure, List<VietnamCityModel>>> getCities();
  Future<Either<Failure, VietnamCityModel>> getDistrictsByCity(int cityCode);
}

class VietnamCityDistrictServiceImpl implements VietnamCityDistrictService {
  @override
  Future<Either<Failure, List<VietnamCityModel>>> getCities() async {
    const uri = ApiUrl.urlGetProvinces;
    try {
      final response = await sl<DioClient>().get(uri);

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is List) {
          final List<VietnamCityModel> vietnamCitiesList = data
              .map((e) => VietnamCityModel.fromMap(e as Map<String, dynamic>))
              .toList();

          return right(vietnamCitiesList);
        } else {
          return left(ExceptionFailure("Unexpected response format"));
        }
      } else {
        return left(ExceptionFailure(
          'Error fetching province data: ${response.statusCode}',
        ));
      }
    } catch (e) {
      return left(ExceptionFailure('Error fetching provinces data: $e'));
    }
  }

  @override
  Future<Either<Failure, VietnamCityModel>> getDistrictsByCity(
      int cityCode) async {
    final uri = ApiUrl.urlGetDistrictsByProvince(cityCode);

    try {
      final response = await sl<DioClient>().get(uri.toString());

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data is Map<String, dynamic>) {
          final city = VietnamCityModel.fromMap(data);
          return right(city);
        } else {
          return left(ExceptionFailure("Unexpected response format"));
        }
      } else {
        return left(ExceptionFailure(
          "Failed to fetch districts: ${response.statusCode}",
        ));
      }
    } catch (e) {
      return left(ExceptionFailure("Exception: $e"));
    }
  }
}
