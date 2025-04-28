import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/models/request/post_review_req.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class PostReviewUsecase extends Usecase<dynamic, PostReviewReq> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<RouteRepository>().postReview(params);
  }
}
