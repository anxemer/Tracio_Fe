import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/blog/entites/category.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class GetCateServiceUseCase extends Usecase<List<CategoryEntity>, NoParams> {
  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) async {
    return await sl<ShopServiceRepository>().getCateService();
  }
}
