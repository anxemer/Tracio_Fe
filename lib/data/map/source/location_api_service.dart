import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/map/models/reponse/get_place_rep.dart';
import 'package:tracio_fe/data/map/models/request/get_place_req.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class LocationApiService {
  Future<Either<Failure, GetPlacesRep>> getPlacesAutocomplete(
      GetPlaceReq request);
  Future<Either<Failure, GetPlaceDetailRep>> getPlaceDetail(
      GetPlaceDetailReq request);
}

class LocationApiServiceImpl extends LocationApiService {
  String apiKey = dotenv.env['GOONG_API_TOKEN'] ?? "";

  @override
  Future<Either<Failure, GetPlacesRep>> getPlacesAutocomplete(
      GetPlaceReq request) async {
    if (apiKey.isEmpty) {
      return left(ExceptionFailure('API key is missing or invalid.'));
    }

    try {
      final Uri uri = ApiUrl.urlGetPlacesAutocomplete(request, apiKey);
      final response = await sl<DioClient>().get(uri.toString());

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
  Future<Either<Failure, GetPlaceDetailRep>> getPlaceDetail(
      GetPlaceDetailReq request) async {
    if (apiKey.isEmpty) {
      return left(ExceptionFailure('API key is missing or invalid.'));
    }

    try {
      final Uri uri = ApiUrl.urlGetPlaceDetail(request, apiKey);
      final response = await sl<DioClient>().get(uri.toString());

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
}
