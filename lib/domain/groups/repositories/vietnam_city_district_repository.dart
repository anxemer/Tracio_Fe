import 'package:dartz/dartz.dart';

abstract class VietnamCityDistrictRepository {
  Future<Either> getCities();
  Future<Either> getDistrictsByCity(int cityCode);
}
