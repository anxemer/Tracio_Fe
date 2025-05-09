import 'package:equatable/equatable.dart';

class RouteFilterState extends Equatable {
  final DateTime? fromDate;
  final DateTime? toDate;
  final String dateString;
  final String? location;
  final double? latitude;
  final double? longitude;
  final int lengthStart;
  final int lengthEnd;
  final int elevationStart;
  final int elevationEnd;
  final int movingTimeStart;
  final int movingTimeEnd;
  final int speedStart;
  final int speedEnd;
  final Map<String, bool> activeField;
  final String
      sortField; // RouteName, City, TotalDistance, ElevationGain, MovingTime, DurationTime, AvgSpeed, MaxSpeed, ReactionCounts, ReviewCounts, CreatedAt, UpdatedAt
  final bool sortDesc;
  final int maxLength = 50;
  final int maxSpeed = 100;
  final int maxElevation = 10000;
  final int maxMovingTime = 24;

  const RouteFilterState(
      {this.fromDate,
      this.toDate,
      this.dateString = "Date",
      this.location,
      this.latitude,
      this.longitude,
      this.lengthStart = 0,
      this.lengthEnd = 50,
      this.elevationStart = 0,
      this.elevationEnd = 10000,
      this.movingTimeStart = 0,
      this.movingTimeEnd = 24,
      this.speedStart = 0,
      this.speedEnd = 100,
      Map<String, bool>? activeField,
      this.sortField = "CreatedAt",
      this.sortDesc = false})
      : activeField = activeField ??
            const {
              "date": false,
              "location": false,
              "speed": false,
              "length": false,
              "moving_time": false,
              "elevation": false,
            };

  /// **Copies state with modifications**
  RouteFilterState copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    String? dateString,
    String? location,
    double? latitude,
    double? longitude,
    int? lengthStart,
    int? lengthEnd,
    int? elevationStart,
    int? elevationEnd,
    int? movingTimeStart,
    int? movingTimeEnd,
    int? speedStart,
    int? speedEnd,
    Map<String, bool>? activeField,
    String? sortField,
    bool? sortDesc,
  }) {
    return RouteFilterState(
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        dateString: dateString ?? this.dateString,
        location: location ?? this.location,
        latitude: latitude,
        longitude: longitude,
        lengthStart: lengthStart ?? this.lengthStart,
        lengthEnd: lengthEnd ?? this.lengthEnd,
        elevationStart: elevationStart ?? this.elevationStart,
        elevationEnd: elevationEnd ?? this.elevationEnd,
        movingTimeStart: movingTimeStart ?? this.movingTimeStart,
        movingTimeEnd: movingTimeEnd ?? this.movingTimeEnd,
        speedStart: speedStart ?? this.speedStart,
        speedEnd: speedEnd ?? this.speedEnd,
        activeField: activeField,
        sortField: sortField ?? this.sortField,
        sortDesc: sortDesc ?? this.sortDesc);
  }

  Map<String, String> toParams({String? searchName}) {
    final Map<String, String> params = {
      'sortField': sortField,
      'sortAsc': sortDesc.toString(),
    };

    if (searchName != null && searchName.isNotEmpty) {
      params['searchName'] = searchName;
    }

    if (activeField['length'] == true) {
      params['minDistance'] = lengthStart.toString();
      params['maxDistance'] = lengthEnd.toString();
    }

    if (activeField['elevation'] == true) {
      params['minElevation'] = elevationStart.toString();
      params['maxElevation'] = elevationEnd.toString();
    }

    if (activeField['moving_time'] == true) {
      params['minMovingTime'] = movingTimeStart.toString();
      params['maxMovingTime'] = movingTimeEnd.toString();
    }

    if (activeField['speed'] == true) {
      params['minAvgSpeed'] = speedStart.toString();
      params['maxAvgSpeed'] = speedEnd.toString();
    }

    if (activeField['location'] == true &&
        latitude != null &&
        longitude != null) {
      params['startLat'] = latitude.toString();
      params['startLng'] = longitude.toString();
    }

    if (activeField['date'] == true) {
      if (fromDate != null) {
        params['fromDate'] = fromDate!.toIso8601String();
      }
      if (toDate != null) {
        params['toDate'] = toDate!.toIso8601String();
      }
    }

    return params;
  }

  @override
  List<Object?> get props => [
        fromDate,
        toDate,
        dateString,
        location,
        latitude,
        longitude,
        lengthStart,
        lengthEnd,
        elevationStart,
        elevationEnd,
        movingTimeStart,
        movingTimeEnd,
        speedStart,
        speedEnd,
        activeField,
        sortField
      ];
}
