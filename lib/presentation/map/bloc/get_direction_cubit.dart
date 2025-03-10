import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/data/map/models/mapbox_direction_req.dart';
import 'package:tracio_fe/domain/map/usecase/get_direction_using_mapbox.dart';
import 'package:tracio_fe/domain/map/usecase/get_elevation.dart';
import 'package:tracio_fe/presentation/map/bloc/get_direction_state.dart';
import 'package:tracio_fe/service_locator.dart';

class GetDirectionCubit extends Cubit<GetDirectionState> {
  GetDirectionCubit() : super(GetDirectionWaiting());

  Future<void> getDirectionUsingMapbox(MapboxDirectionsRequest request) async {
    emit(GetDirectionLoading());

    var data = await sl<GetDirectionUsingMapboxUseCase>().call(params: request);

    data.fold((error) {
      emit(GetDirectionFailure(errorMessage: error));
    }, (directionData) async {
      // Now fetch elevation using polyline
      var elevationData = await sl<GetElevationUseCase>()
          .call(params: directionData.polyLineOverview!);

      elevationData.fold((error) {
        emit(GetElevationFailure(errorMessage: error));
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
    var data = await sl<GetElevationUseCase>().call(params: encodedPolyline);
    data.fold((error) {
      emit(GetElevationFailure(errorMessage: error));
    }, (data) {
      emit(GetElevationLoaded(elevationPoints: data));
    });
  }
}
