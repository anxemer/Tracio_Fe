import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/shop/models/reply_review_req.dart';
import 'package:Tracio/domain/shop/repositories/shop_service_repository.dart';

import '../../../service_locator.dart';

class ReplyReviewUseCase extends Usecase<bool, ReplyReviewReq> {
  @override
  Future<Either<Failure, bool>> call(params) async {
    return await sl<ShopServiceRepository>().replyReview(params);
  }
}
