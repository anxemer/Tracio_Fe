import 'package:Tracio/data/map/models/request/post_route_media_req.dart';
import 'package:Tracio/data/map/models/request/update_route_req.dart';
import 'package:Tracio/data/map/models/route_blog_review.dart';
import 'package:Tracio/domain/map/entities/route.dart';
import 'package:Tracio/domain/map/entities/route_media.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/map/models/request/finish_tracking_req.dart';
import 'package:Tracio/data/map/models/request/post_reply_req.dart';
import 'package:Tracio/data/map/models/request/post_review_req.dart';
import 'package:Tracio/data/map/models/response/get_route_blog_rep.dart';
import 'package:Tracio/data/map/models/response/get_route_blog_review_rep.dart';
import 'package:Tracio/data/map/models/response/get_route_rep.dart';
import 'package:Tracio/data/map/models/request/get_route_req.dart';
import 'package:Tracio/data/map/models/response/get_route_reply_rep.dart';
import 'package:Tracio/data/map/models/request/mapbox_direction_req.dart';
import 'package:Tracio/data/map/models/request/post_route_req.dart';
import 'package:Tracio/data/map/source/route_api_service.dart';
import 'package:Tracio/domain/map/entities/mapbox_direction_rep.dart';
import 'package:Tracio/domain/map/entities/route_detail.dart';
import 'package:Tracio/domain/map/repositories/route_repository.dart';
import 'package:Tracio/service_locator.dart';

import '../../../domain/map/entities/route_reply.dart';
import '../models/route_reply.dart';

class RouteRepositoryImpl extends RouteRepository {
  @override
  Future<Either<Failure, MapboxDirectionResponseEntity>>
      getDirectionUsingMapbox(MapboxDirectionsRequest request) async {
    var returnedData = await sl<RouteApiService>().getRouteUsingMapBox(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      final direction = MapboxDirectionResponseEntity.fromMap(data);
      return right(direction);
    });
  }

  @override
  Future<Either<Failure, GetRouteRepModel>> getRoutes(
      GetRouteReq request) async {
    var returnedData = await sl<RouteApiService>().getRoutes(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> postRoute(PostRouteReq request) async {
    var returnedData = await sl<RouteApiService>().postRoute(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, RouteDetailEntity?>> finishTracking(
      FinishTrackingReq request) async {
    var returnedData = await sl<RouteApiService>().finishTracking(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> startTracking(
      Map<String, dynamic> request) async {
    var returnedData = await sl<RouteApiService>().startTracking(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, GetRouteBlogRep>> getRouteBlogList(
      Map<String, String> params) async {
    var returnedData = await sl<RouteApiService>().getRouteBlogList(params);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, GetRouteBlogReviewRep>> getRouteBlogReviews(
      int routeId, Map<String, String> params) async {
    var returnedData = await sl<RouteApiService>()
        .getRouteBlogReviews(routeId, params: params);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, GetRouteReplyRep>> getRouteRelies(
      Map<String, dynamic> params) async {
    var returnedData =
        await sl<RouteApiService>().getRouteBlogReviewReplies(params);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> deleteReply(int replyId) async {
    var returnedData = await sl<RouteApiService>().deleteReply(replyId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> deleteReview(int reviewId) async {
    var returnedData = await sl<RouteApiService>().deleteReview(reviewId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, RouteReplyEntity>> postReply(
      PostReplyReq request) async {
    try {
      var returnedData = await sl<RouteApiService>().postReply(request);

      return Right(returnedData);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, RouteBlogReviewModel>> postReview(
      PostReviewReq request) async {
    try {
      var returnedData = await sl<RouteApiService>().postReview(request);
      return Right(returnedData);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, RouteDetailEntity>> getRouteDetail(int routeId) async {
    var returnedData = await sl<RouteApiService>().getRouteDetail(routeId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> deleteRouteMediaFiles(int pictureId) async {
    var returnedData =
        await sl<RouteApiService>().deleteRouteMediaFiles(pictureId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, RouteEntity>> editRouteTracking(
      UpdateRouteReq request) async {
    var returnedData = await sl<RouteApiService>().editRouteTracking(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, RouteEntity>> getOnGoingInRoute() async {
    var returnedData = await sl<RouteApiService>().getOnGoingInRoute();
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, List<RouteMediaEntity>>> getRouteMediaFiles(
      int routeId) async {
    var returnedData = await sl<RouteApiService>().getRouteMediaFiles(routeId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, RouteMediaEntity>> postRouteMediaFiles(
      PostRouteMediaReq request) async {
    var returnedData = await sl<RouteApiService>().postRouteMediaFiles(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> deleteRoute(int routeId) async {
    var returnedData = await sl<RouteApiService>().deleteRoute(routeId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }
}
