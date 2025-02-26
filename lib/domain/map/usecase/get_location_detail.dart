import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/map/repositories/location_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetLocationDetailUseCase extends Usecase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<LocationRepository>().getPlaceDetail(params);
  }
}