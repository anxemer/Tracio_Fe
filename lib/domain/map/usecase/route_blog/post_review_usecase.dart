import 'package:Tracio/domain/map/entities/route_reply.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/map/models/request/post_review_req.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class PostReviewUsecase extends Usecase<RouteReplyEntity, PostReviewReq> {
  @override
  Future<Either<Failure, RouteReplyEntity>> call(params) async {
    return await sl<RouteRepository>().postReview(params);
  }
}
