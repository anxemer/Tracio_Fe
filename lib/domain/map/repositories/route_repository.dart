import 'package:Tracio/data/map/models/request/post_route_media_req.dart';
import 'package:Tracio/data/map/models/request/update_route_req.dart';
import 'package:Tracio/domain/map/entities/route.dart';
import 'package:Tracio/domain/map/entities/route_media.dart';
import 'package:Tracio/domain/map/entities/route_reply.dart';
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
import 'package:Tracio/domain/map/entities/mapbox_direction_rep.dart';
import 'package:Tracio/domain/map/entities/route_detail.dart';

import '../../../data/map/models/route_reply.dart';
import '../entities/route_review.dart';

abstract class RouteRepository {
  Future<Either<Failure, GetRouteRepModel>> getRoutes(GetRouteReq request);
  Future<Either<Failure, MapboxDirectionResponseEntity>>
      getDirectionUsingMapbox(MapboxDirectionsRequest request);
  Future<Either<Failure, dynamic>> postRoute(PostRouteReq request);
  Future<Either<Failure, dynamic>> startTracking(Map<String, dynamic> request);
  Future<Either<Failure, RouteDetailEntity?>> finishTracking(
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
  Future<Either<Failure, RouteReviewEntity>> postReview(PostReviewReq request);
  Future<Either<Failure, RouteReplyEntity>> postReply(PostReplyReq request);
  Future<Either<Failure, RouteEntity>> getOnGoingInRoute();
  Future<Either<Failure, RouteEntity>> editRouteTracking(
      UpdateRouteReq request);
  Future<Either<Failure, List<RouteMediaEntity>>> getRouteMediaFiles(
      int routeId);
  Future<Either<Failure, RouteMediaEntity>> postRouteMediaFiles(
      PostRouteMediaReq request);
  Future<Either<Failure, dynamic>> deleteRouteMediaFiles(int pictureId);
  Future<Either<Failure, dynamic>> deleteRoute(int routeId);
}
