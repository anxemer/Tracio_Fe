import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/map/models/mapbox_direction_req.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class RouteApiService {
  Future<Either> getRoutes();
  //TODO: post_route_req
  Future<Either> postRoute();
  Future<Either> getRouteUsingMapBox(MapboxDirectionsRequest request);
}

class RouteApiServiceImpl extends RouteApiService {
  @override
  Future<Either<String, dynamic>> getRouteUsingMapBox(
      MapboxDirectionsRequest request) async {
    try {
      Uri apiUrl = ApiUrl.urlGetDirectionUsingMapbox(request);
      var response = await sl<DioClient>().get(apiUrl.toString());

      if (response.statusCode == 200) {
        return right(response.data);
      } else {
        return left('Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return left(e.response?.data['message'] ?? 'An error occurred');
    } catch (e) {
      return left('An unexpected error occurred: $e');
    }
  }

  @override
  Future<Either> getRoutes() {
    // TODO: implement getRoutes
    throw UnimplementedError();
  }

  @override
  Future<Either> postRoute() {
    // TODO: implement postRoute
    throw UnimplementedError();
  }
}
