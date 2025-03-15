import 'package:dartz/dartz.dart';
import 'package:google_polyline_algorithm/google_polyline_algorithm.dart';
import 'package:map_elevation/map_elevation.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class ElevationApiService {
  Future<Either<Failure, List<ElevationPoint>>> postElevationFromPolyline(
      String encodedPolyline);
}

class ElevationApiServiceImpl extends ElevationApiService {
  @override
  Future<Either<Failure, List<ElevationPoint>>> postElevationFromPolyline(
      String encodedPolyline) async {
    List<List<num>> decodedPoints = decodePolyline(encodedPolyline);
    List<Location> locations = decodedPoints
        .map((point) => Location(point[0].toDouble(), point[1].toDouble()))
        .toList();

    Uri uri = ApiUrl.urlGetEleUsingOpenElevation();
    Map<String, dynamic> locationsParam = {
      "locations": locations.map((loc) => loc.toJson()).toList()
    };
    List<ElevationPoint> elevations = [];

    try {
      final response =
          await sl<DioClient>().post(uri.toString(), data: locationsParam);

      if (response.statusCode == 200) {
        final jsonResponse = response.data;

        if (jsonResponse['results'] != null) {
          // Extract elevations from the results
          for (var result in jsonResponse['results']) {
            if (result != null) {
              ElevationPoint tmp = ElevationPoint(
                  result["latitude"], result["longitude"], result["elevation"]);
              elevations.add(tmp);
            }
          }
        } else {
          return left(ExceptionFailure("Error fetching elevation data"));
        }
      } else {
        return left(ExceptionFailure(
            'Error fetching elevation data: ${response.statusCode}'));
      }
    } catch (e) {
      return left(ExceptionFailure('Error fetching elevation data: $e'));
    }

    return right(elevations);
  }
}

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
