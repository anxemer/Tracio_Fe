import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/map/models/response/get_route_rep.dart';
import 'package:tracio_fe/data/map/models/request/get_route_req.dart';
import 'package:tracio_fe/data/map/models/request/mapbox_direction_req.dart';
import 'package:tracio_fe/data/map/models/request/post_route_req.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class RouteApiService {
  Future<Either> getRoutes(GetRouteReq request);
  Future<Either> postRoute(PostRouteReq request);
  Future<Either> getRouteUsingMapBox(MapboxDirectionsRequest request);
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
}
