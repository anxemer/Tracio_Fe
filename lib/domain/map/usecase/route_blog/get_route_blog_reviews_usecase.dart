import 'package:dartz/dartz.dart';

import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/models/response/get_route_blog_review_rep.dart';
import 'package:tracio_fe/domain/map/repositories/route_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetRouteBlogReviewsParams {
  final int routeId;
  final int pageSize;
  final int pageNumber;
  GetRouteBlogReviewsParams({
    required this.routeId,
    this.pageSize = 5,
    this.pageNumber = 1,
  });

  Map<String, String> toParams() {
    return <String, String>{
      'pageSize': pageSize.toString(),
      'pageNumber': pageNumber.toString(),
    };
  }
}

class GetRouteBlogReviewsUsecase
    extends Usecase<dynamic, GetRouteBlogReviewsParams> {
  @override
  Future<Either<Failure, GetRouteBlogReviewRep>> call(params) async {
    return await sl<RouteRepository>()
        .getRouteBlogReviews(params.routeId, params.toParams());
  }
}
