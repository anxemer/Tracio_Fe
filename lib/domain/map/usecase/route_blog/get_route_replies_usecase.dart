// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/map/entities/route_reply.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetRouteRepliesUsecaseParams {
  int reviewId;
  int? replyId;
  int pageNumber;
  int pageSize;
  GetRouteRepliesUsecaseParams({
    required this.reviewId,
    this.replyId,
    this.pageNumber = 1,
    this.pageSize = 5,
  });

  Map<String, dynamic> toParam() {
    var params = {
      "reviewId": reviewId.toString(),
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString()
    };

    replyId != null ? params["replyId"] = replyId!.toString() : null;
    return params;
  }
}

class GetRouteRepliesUsecase
    extends Usecase<dynamic, GetRouteRepliesUsecaseParams> {
  @override
  Future<Either<Failure, RouteReplyPaginationEntity>> call(
      GetRouteRepliesUsecaseParams params) async {
    return await sl<RouteRepository>().getRouteRelies(params.toParam());
  }
}
