import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/location/model/city.dart';

import '../../../service_locator.dart';

abstract class CityApiSource {
  Future<List<City>> getCity();
}

class CityApiSourceImpl extends CityApiSource {
  @override
  Future<List<City>> getCity() async {
    var response = await sl<DioClient>().get(ApiUrl.getCity);

    return List.from(response.data['data'])
        .map((e) => City.fromJson(e))
        .toList();
  }
}
