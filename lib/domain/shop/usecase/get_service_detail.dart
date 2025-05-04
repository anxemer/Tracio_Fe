import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/shop/entities/response/detail_service_response_entity.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class GetServiceDetailUseCase
    extends Usecase<DetailServiceResponseEntity, int> {
  @override
  Future<Either<Failure, DetailServiceResponseEntity>> call(params) async {
    return await sl<ShopServiceRepository>().getServiceDetail(params);
  }
}
