import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/data/map/models/request/mapbox_direction_req.dart';
import 'package:Tracio/domain/map/usecase/get_direction_using_mapbox.dart';
import 'package:Tracio/domain/map/usecase/get_elevation.dart';
import 'package:Tracio/presentation/map/bloc/get_direction_state.dart';
import 'package:Tracio/service_locator.dart';
import "package:turf/turf.dart";

class GetDirectionCubit extends Cubit<GetDirectionState> {
  GetDirectionCubit() : super(GetDirectionWaiting());

  List<Feature<Point>> getPointsAlongLine(LineString lineString,
      {int meterInterval = 1}) {
    final feature = Feature<LineString>(geometry: lineString);

    // Calculate the total length of the line (in meters)
    final double totalLength = length(feature, Unit.meters).toDouble();

    final List<Feature<Point>> points = [];

    // Walk every 1 meter along the line
    for (double distance = 0;
        distance <= totalLength;
        distance += meterInterval) {
      final point = along(feature, distance, Unit.meters);
      points.add(point);
    }

    return points;
  }

  List<Position> coordAll(List<Feature<Point>> features) {
    return features
        .map((f) => f.geometry?.coordinates)
        .whereType<Position>()
        .toList();
  }

  String encodePolyline(List<Position> coords, {int precision = 5}) {
    return Polyline.encode(coords, precision: precision);
  }

  Future<void> getDirectionUsingMapbox(MapboxDirectionsRequest request) async {
    emit(GetDirectionLoading());

    var data = await sl<GetDirectionUsingMapboxUseCase>().call(request);

    data.fold((error) {
      emit(GetDirectionFailure(errorMessage: error.toString()));
    }, (directionData) async {
      List<Feature<Point>> points =
          getPointsAlongLine(directionData.geometry!, meterInterval: 5);
      final coords = coordAll(points);
      final polyline = encodePolyline(coords);
      var elevationData = await sl<GetElevationUseCase>().call(polyline);

      elevationData.fold((error) {
        emit(GetElevationFailure(errorMessage: error.toString()));
      }, (elevationPoints) {
        // Emit updated state with both direction & elevation
        emit(GetDirectionLoaded(
            direction: directionData, elevationPoints: elevationPoints));
      });
    });
  }

  Future<void> getElevation(String encodedPolyline) async {
    emit(GetElevationLoading());
    //Elevation point
    var data = await sl<GetElevationUseCase>().call(encodedPolyline);
    data.fold((error) {
      emit(GetElevationFailure(errorMessage: error.toString()));
    }, (data) {
      emit(GetElevationLoaded(elevationPoints: data));
    });
  }
}
