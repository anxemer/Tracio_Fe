import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/shop/models/get_review_req.dart';
import 'package:Tracio/domain/shop/entities/response/review_service_response_entity.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class GetReviewServiceUseCase
    extends Usecase<ReviewServiceResponseEntity, GetReviewReq> {
  @override
  Future<Either<Failure, ReviewServiceResponseEntity>> call(params) async {
    return await sl<ShopServiceRepository>().getReviewService(params);
  }
}
