import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/shop/entities/service_response_entity.dart';
import 'package:tracio_fe/domain/shop/entities/shop_service_entity.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class GetServiceUseCase extends Usecase<ServiceResponseEntity, NoParams> {
  @override
  Future<Either<Failure, ServiceResponseEntity>> call(NoParams params) async {
    return await sl<ShopServiceRepository>().getService();
  }
}
