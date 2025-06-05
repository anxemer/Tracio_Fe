import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/map/models/request/post_review_req.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

import '../../entities/route_review.dart';

class PostReviewUsecase extends Usecase<RouteReviewEntity, PostReviewReq> {
  @override
  Future<Either<Failure, RouteReviewEntity>> call(params) async {
    return await sl<RouteRepository>().postReview(params);
  }
}
