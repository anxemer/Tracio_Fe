import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/shop/models/create_shop_profile_req.dart';
import 'package:Tracio/service_locator.dart';

import '../repositories/shop_service_repository.dart';

class RegisterShopUseCase extends Usecase<bool, CreateShopProfileReq> {
  @override
  Future<Either<Failure, bool>> call(params) async {
    return await sl<ShopServiceRepository>().registerShop(params);
  }
}
