import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/shop/models/create_service_req.dart';
import 'package:tracio_fe/data/shop/repositories/shop_service_repository_impl.dart';
import 'package:tracio_fe/service_locator.dart';

import '../repositories/shop_service_repository.dart';

class CreateServiceUseCase extends Usecase<bool, CreateServiceReq> {
  @override
  Future<Either<Failure, bool>> call(CreateServiceReq params) async {
    return await sl<ShopServiceRepository>().createService(params);
  }
}
