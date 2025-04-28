import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/shop/entities/response/shop_profile_entity.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetShopProfileUseCase extends Usecase<ShopProfileEntity, NoParams> {
  @override
  Future<Either<Failure, ShopProfileEntity>> call(NoParams params) async {
    return await sl<ShopServiceRepository>().getShopProfile();
  }
}
