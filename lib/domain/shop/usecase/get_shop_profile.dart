import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/shop/entities/response/shop_profile_entity.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetShopProfileUseCase extends Usecase<ShopProfileEntity, NoParams> {
  @override
  Future<Either<Failure, ShopProfileEntity>> call(NoParams params) async {
    return await sl<ShopServiceRepository>().getShopProfile();
  }
}
