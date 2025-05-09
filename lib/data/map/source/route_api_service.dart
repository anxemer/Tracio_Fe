import 'package:Tracio/data/map/models/request/post_route_media_req.dart';
import 'package:Tracio/data/map/models/request/update_route_req.dart';
import 'package:Tracio/data/map/models/route.dart';
import 'package:Tracio/data/map/models/route_media.dart';
import 'package:Tracio/domain/map/entities/route.dart';
import 'package:Tracio/domain/map/entities/route_media.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/network/dio_client.dart';
import 'package:Tracio/data/map/models/request/finish_tracking_req.dart';
import 'package:Tracio/data/map/models/request/post_reply_req.dart';
import 'package:Tracio/data/map/models/request/post_review_req.dart';
import 'package:Tracio/data/map/models/response/get_route_blog_rep.dart';
import 'package:Tracio/data/map/models/response/get_route_blog_review_rep.dart';
import 'package:Tracio/data/map/models/response/get_route_rep.dart';
import 'package:Tracio/data/map/models/request/get_route_req.dart';
import 'package:Tracio/data/map/models/request/mapbox_direction_req.dart';
import 'package:Tracio/data/map/models/request/post_route_req.dart';
import 'package:Tracio/data/map/models/response/get_route_reply_rep.dart';
import 'package:Tracio/data/map/models/route_detail.dart';
import 'package:Tracio/domain/map/entities/route_detail.dart';
import 'package:Tracio/service_locator.dart';

abstract class RouteApiService {
  Future<Either> getRoutes(GetRouteReq request);
  Future<Either> postRoute(PostRouteReq request);
  Future<Either> getRouteUsingMapBox(MapboxDirectionsRequest request);
  Future<Either<Failure, dynamic>> startTracking(Map<String, dynamic> request);
  Future<Either<Failure, RouteDetailEntity?>> finishTracking(
      FinishTrackingReq request);
  Future<Either<Failure, RouteDetailModel>> getRouteDetail(int routeId);
  Future<Either<Failure, dynamic>> getRouteBlogList(Map<String, String> params);
  Future<Either<Failure, dynamic>> getRouteBlogReviews(int routeId,
      {Map<String, String> params});
  Future<Either<Failure, dynamic>> getRouteBlogReviewReplies(
      Map<String, dynamic> params);
  Future<Either<Failure, dynamic>> postReview(PostReviewReq request);
  Future<Either<Failure, dynamic>> postReply(PostReplyReq request);
  Future<Either<Failure, dynamic>> deleteReview(int reviewId);
  Future<Either<Failure, dynamic>> deleteReply(int replyId);
  Future<Either<Failure, dynamic>> getOnGoingInRoute();
  Future<Either<Failure, RouteEntity>> editRouteTracking(
      UpdateRouteReq request);
  Future<Either<Failure, List<RouteMediaEntity>>> getRouteMediaFiles(
      int routeId);
  Future<Either<Failure, RouteMediaEntity>> postRouteMediaFiles(
      PostRouteMediaReq request);
  Future<Either<Failure, dynamic>> deleteRouteMediaFiles(int pictureId);
}

class RouteApiServiceImpl extends RouteApiService {
  @override
  Future<Either<Failure, dynamic>> getRouteUsingMapBox(
      MapboxDirectionsRequest request) async {
    try {
      Uri apiUrl = ApiUrl.urlGetDirectionUsingMapbox(request);
      var response = await sl<DioClient>().get(apiUrl.toString());

      if (response.statusCode == 200) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(e.response?.data['message'] ?? 'An error occurred');
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, GetRouteRepModel>> getRoutes(
      GetRouteReq request) async {
    try {
      Uri apiUrl = ApiUrl.urlGetRoutes(request);
      var response = await sl<DioClient>().get(apiUrl.toString());

      if (response.statusCode == 200) {
        final responseData = GetRouteRepModel.fromMap(response.data);
        return right(responseData);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> postRoute(PostRouteReq request) async {
    try {
      var requestJson = request.toJson();
      var response =
          await sl<DioClient>().post(ApiUrl.postRoute, data: requestJson);

      if (response.statusCode == 201) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteDetailEntity?>> finishTracking(
      FinishTrackingReq request) async {
    try {
      FormData formData = await request.toFormData();
      var response = await sl<DioClient>().put(ApiUrl.finishTracking,
          data: formData, options: Options(contentType: "multipart/form-data"));

      if (response.statusCode == 200) {
        return right(response.data["result"] != null
            ? RouteDetailModel.fromMap(response.data["result"])
            : null);
      } else if (response.statusCode == 403) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 403));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> startTracking(
      Map<String, dynamic> request) async {
    try {
      var response =
          await sl<DioClient>().post(ApiUrl.startTracking, data: request);

      if (response.statusCode == 201) {
        return right(response.data);
      } else if (response.statusCode == 403) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 403));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(ExceptionFailure(e.message ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, GetRouteBlogRep>> getRouteBlogList(
      Map<String, String> params) async {
    try {
      Uri apiUrl = ApiUrl.urlGetRouteBlogList(params);
      var response = await sl<DioClient>().get(apiUrl.toString());

      if (response.statusCode == 200) {
        final responseData = GetRouteBlogRep.fromMap(response.data["result"]);
        return right(responseData);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, GetRouteBlogReviewRep>> getRouteBlogReviews(
      int routeId,
      {Map<String, String>? params}) async {
    try {
      Uri apiUrl = ApiUrl.urlGetRouteBlogReviews(routeId, params);
      var response = await sl<DioClient>().get(apiUrl.toString());

      if (response.statusCode == 200) {
        final responseData =
            GetRouteBlogReviewRep.fromMap(response.data["result"]);
        return right(responseData);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, GetRouteReplyRep>> getRouteBlogReviewReplies(
      Map<String, dynamic> params) async {
    try {
      Uri apiUrl =
          ApiUrl.urlGetRouteReviewReplies.replace(queryParameters: params);
      var response = await sl<DioClient>().get(apiUrl.toString());

      if (response.statusCode == 200) {
        final responseData = GetRouteReplyRep.fromMap(response.data["result"]);
        return right(responseData);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteReply(int replyId) async {
    try {
      Uri apiUrl = ApiUrl.urlDeleteRouteReply(replyId);

      var response = await sl<DioClient>().delete(apiUrl.toString());

      if (response.statusCode == 204) {
        return right(response["result"]);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteReview(int reviewId) async {
    try {
      Uri apiUrl = ApiUrl.urlDeleteRouteReview(reviewId);

      var response = await sl<DioClient>().delete(apiUrl.toString());

      if (response.statusCode == 204) {
        return right(response["result"]);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> postReply(PostReplyReq request) async {
    try {
      var formData = request.toFormData();
      var response = await sl<DioClient>().post(
        ApiUrl.urlPostRouteReply.toString(),
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      if (response.statusCode == 201) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> postReview(PostReviewReq request) async {
    try {
      var formData = request.toFormData();
      var response = await sl<DioClient>().post(
        ApiUrl.urlPostRouteReview.toString(),
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      if (response.statusCode == 201) {
        return right(response.data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteDetailModel>> getRouteDetail(int routeId) async {
    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlGetRouteDetail(routeId).toString());

      if (response.statusCode == 200) {
        return right(RouteDetailModel.fromMap(response.data["result"]));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteRouteMediaFiles(int pictureId) async {
    try {
      Uri apiUrl = ApiUrl.urlDeleteRouteMediaFiles(pictureId);

      var response = await sl<DioClient>().delete(apiUrl.toString());

      if (response.statusCode == 204) {
        return right(response["result"]);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteEntity>> editRouteTracking(
      UpdateRouteReq request) async {
    try {
      var response = await sl<DioClient>().put(
          ApiUrl.urlUpdateTrackingRoute(request.routeId).toString(),
          data: request.toMap());

      if (response.statusCode == 200) {
        return right(RouteModel.fromMap(response.data["result"]));
      } else if (response.statusCode == 403) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 403));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteEntity?>> getOnGoingInRoute() async {
    try {
      var response =
          await sl<DioClient>().get(ApiUrl.urlGetRouteOnGoingIn.toString());

      if (response.statusCode == 200) {
        return right(response.data["result"] != null
            ? RouteDetailModel.fromMap(response.data["result"])
            : null);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RouteMediaEntity>>> getRouteMediaFiles(
      int routeId) async {
    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlGetRouteMediaFiles(routeId).toString());

      if (response.statusCode == 200) {
        final List data = response.data["result"];
        final mediaList = data.map((e) => RouteMediaModel.fromMap(e)).toList();
        return right(mediaList);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, RouteMediaEntity>> postRouteMediaFiles(
      PostRouteMediaReq request) async {
    try {
      var formData = await request.toFormData();
      var response = await sl<DioClient>().post(
        ApiUrl.urlPostRouteMediaFiles(request.routeId).toString(),
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      if (response.statusCode == 201) {
        return right(RouteMediaModel.fromMap(response.data["result"]));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(
          ExceptionFailure(e.response?.data['message'] ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }
}
