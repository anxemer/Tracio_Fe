import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/shop/entities/response/service_response_entity.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../data/shop/models/get_service_req.dart';
import '../../../service_locator.dart';

class GetServiceUseCase extends Usecase<ServiceResponseEntity, GetServiceReq> {
  @override
  Future<Either<Failure, ServiceResponseEntity>> call(params) async {
    return await sl<ShopServiceRepository>().getService(params);
  }
}
