import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/shop/models/create_service_req.dart';
import 'package:Tracio/data/shop/repositories/shop_service_repository_impl.dart';
import 'package:Tracio/service_locator.dart';

import '../repositories/shop_service_repository.dart';

class CreateServiceUseCase extends Usecase<bool, CreateServiceReq> {
  @override
  Future<Either<Failure, bool>> call(CreateServiceReq params) async {
    return await sl<ShopServiceRepository>().createService(params);
  }
}
