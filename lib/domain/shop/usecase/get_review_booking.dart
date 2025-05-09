import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/shop/entities/response/review_service_entity.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class GetReviewBookingUseCase extends Usecase<ReviewServiceEntity, int> {
  @override
  Future<Either<Failure, ReviewServiceEntity>> call(params) async {
    return await sl<ShopServiceRepository>().getReviewBooking(params);
  }
}
