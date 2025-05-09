import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/shop/entities/response/service_response_entity.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';

import '../../../data/shop/models/get_service_req.dart';
import '../../../service_locator.dart';

class GetServiceUseCase extends Usecase<ServiceResponseEntity, GetServiceReq> {
  @override
  Future<Either<Failure, ServiceResponseEntity>> call(params) async {
    return await sl<ShopServiceRepository>().getService(params);
  }
}
