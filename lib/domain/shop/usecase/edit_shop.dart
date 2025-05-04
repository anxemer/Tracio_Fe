import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/shop/models/create_shop_profile_req.dart';
import 'package:tracio_fe/service_locator.dart';

import '../repositories/shop_service_repository.dart';

class EditShopUseCase extends Usecase<bool, CreateShopProfileReq> {
  @override
  Future<Either<Failure, bool>> call(params) async {
    return await sl<ShopServiceRepository>().eidtShop(params);
  }
}
