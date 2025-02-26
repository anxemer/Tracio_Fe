import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/data/map/models/get_place_req.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class LocationApiService {
  Future<Either<String, dynamic>> getPlacesAutocomplete(GetPlaceReq request);
  Future<Either<String, dynamic>> getPlaceDetail(GetPlaceDetailReq request);
}

class LocationApiServiceImpl extends LocationApiService {
  String apiKey = dotenv.env['GOONG_API_TOKEN'] ?? "";

  @override
  Future<Either<String, dynamic>> getPlacesAutocomplete(
      GetPlaceReq request) async {
    if (apiKey.isEmpty) {
      return left('API key is missing or invalid.');
    }

    try {
      final Uri uri = ApiUrl.urlGetPlacesAutocomplete(request, apiKey);
      final response = await sl<DioClient>().get(uri.toString());

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
  Future<Either<String, dynamic>> getPlaceDetail(
      GetPlaceDetailReq request) async {
    if (apiKey.isEmpty) {
      return left('API key is missing or invalid.');
    }

    try {
      final Uri uri = ApiUrl.urlGetPlaceDetail(request, apiKey);
      final response = await sl<DioClient>().get(uri.toString());

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
}
