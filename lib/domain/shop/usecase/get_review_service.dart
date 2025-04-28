import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/shop/models/get_review_req.dart';
import 'package:tracio_fe/domain/shop/entities/response/review_service_response_entity.dart';
import 'package:tracio_fe/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class GetReviewServiceUseCase
    extends Usecase<ReviewServiceResponseEntity, GetReviewReq> {
  @override
  Future<Either<Failure, ReviewServiceResponseEntity>> call(params) async {
    return await sl<ShopServiceRepository>().getReviewService(params);
  }
}
