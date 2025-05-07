import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/presentation/library/bloc/route_filter_state.dart';

class RouteFilterCubit extends Cubit<RouteFilterState> {
  RouteFilterCubit() : super(const RouteFilterState());

  int maxLength = 50;
  int maxSpeed = 100;
  int maxElevation = 10000;
  int maxMovingTime = 24;

  /// **Set Date Range & Update Active Field**
  void setDateRange(DateTime? from, DateTime? to, String? dateString) {
    emit(state.copyWith(
      fromDate: from,
      toDate: to,
      dateString: dateString,
      activeField: {
        ...state.activeField,
        "date": from != null || to != null,
      },
    ));
  }

  /// **Set Location & Update Active Field**
  void setLocation(String? location, {double? longitude, double? latitude}) {
    emit(state.copyWith(
      location: location,
      latitude: latitude,
      longitude: longitude,
      activeField: {
        ...state.activeField,
        "location": location != null &&
            latitude != null &&
            longitude != null &&
            location.isNotEmpty,
      },
    ));
  }

  /// **Set Range Values & Update Active Field**
  void setRange({
    required String type,
    required int start,
    required int end,
  }) {
    Map<String, bool> updatedActiveField = {...state.activeField};

    switch (type) {
      case "length":
        updatedActiveField["length"] = !(start == 0 && end == 50);
        emit(state.copyWith(
            lengthStart: start,
            lengthEnd: end,
            activeField: updatedActiveField));
        break;
      case "elevation":
        updatedActiveField["elevation"] = !(start == 0 && end == 10000);
        emit(state.copyWith(
            elevationStart: start,
            elevationEnd: end,
            activeField: updatedActiveField));
        break;
      case "moving_time":
        updatedActiveField["moving_time"] = !(start == 0 && end == 24);
        emit(state.copyWith(
            movingTimeStart: start,
            movingTimeEnd: end,
            activeField: updatedActiveField));
        break;
      case "speed":
        updatedActiveField["speed"] = !(start == 0 && end == 100);
        emit(state.copyWith(
            speedStart: start, speedEnd: end, activeField: updatedActiveField));
        break;
    }
  }

  /// **Reset a Specific Filter**
  void resetFilter(String type) {
    switch (type) {
      case "date":
        emit(state.copyWith(fromDate: null, toDate: null, activeField: {
          ...state.activeField,
          "date": false,
        }));
        break;
      case "location":
        emit(state.copyWith(location: null, activeField: {
          ...state.activeField,
          "location": false,
        }));
        break;
      case "length":
        emit(state.copyWith(lengthStart: 0, lengthEnd: 50, activeField: {
          ...state.activeField,
          "length": false,
        }));
        break;
      case "elevation":
        emit(state
            .copyWith(elevationStart: 0, elevationEnd: 10000, activeField: {
          ...state.activeField,
          "elevation": false,
        }));
        break;
      case "moving_time":
        emit(
            state.copyWith(movingTimeStart: 0, movingTimeEnd: 24, activeField: {
          ...state.activeField,
          "moving_time": false,
        }));
        break;
      case "speed":
        emit(state.copyWith(speedStart: 0, speedEnd: 100, activeField: {
          ...state.activeField,
          "speed": false,
        }));
        break;
    }
  }

  void setSortField(String sortField) {
    emit(state.copyWith(sortField: sortField, activeField: {
      ...state.activeField,
    }));
  }
}
