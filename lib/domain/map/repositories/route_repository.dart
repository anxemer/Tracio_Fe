import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/map/models/request/finish_tracking_req.dart';
import 'package:tracio_fe/data/map/models/request/post_reply_req.dart';
import 'package:tracio_fe/data/map/models/request/post_review_req.dart';
import 'package:tracio_fe/data/map/models/response/get_route_blog_rep.dart';
import 'package:tracio_fe/data/map/models/response/get_route_blog_review_rep.dart';
import 'package:tracio_fe/data/map/models/response/get_route_rep.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/data/map/models/response/get_route_reply_rep.dart';
import 'package:tracio_fe/data/map/models/request/mapbox_direction_req.dart';
import 'package:tracio_fe/data/map/models/request/post_route_req.dart';
import 'package:tracio_fe/domain/map/entities/mapbox_direction_rep.dart';
import 'package:tracio_fe/domain/map/entities/route_detail.dart';

abstract class RouteRepository {
  Future<Either<Failure, GetRouteRepModel>> getRoutes(GetRouteReq request);
  Future<Either<Failure, MapboxDirectionResponseEntity>>
      getDirectionUsingMapbox(MapboxDirectionsRequest request);
  Future<Either<Failure, dynamic>> postRoute(PostRouteReq request);
  Future<Either<Failure, dynamic>> startTracking(Map<String, dynamic> request);
  Future<Either<Failure, RouteDetailEntity>> finishTracking(
      FinishTrackingReq request);
  Future<Either<Failure, RouteDetailEntity>> getRouteDetail(int routeId);
  Future<Either<Failure, GetRouteBlogRep>> getRouteBlogList(
      Map<String, String> params);
  Future<Either<Failure, GetRouteBlogReviewRep>> getRouteBlogReviews(
      int routeId, Map<String, String> params);
  Future<Either<Failure, GetRouteReplyRep>> getRouteRelies(
      Map<String, dynamic> params);
  Future<Either<Failure, dynamic>> deleteReview(int reviewId);
  Future<Either<Failure, dynamic>> deleteReply(int replyId);
  Future<Either<Failure, dynamic>> postReview(PostReviewReq request);
  Future<Either<Failure, dynamic>> postReply(PostReplyReq request);
}
