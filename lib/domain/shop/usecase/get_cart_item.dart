import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/shop/entities/response/cart_item_entity.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class GetCartItemUseCase extends Usecase<List<CartItemEntity>, NoParams> {
  @override
  Future<Either<Failure, List<CartItemEntity>>> call(NoParams params) async {
    return await sl<ShopServiceRepository>().getCartitem();
  }
}
