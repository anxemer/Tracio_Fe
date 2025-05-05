import 'package:equatable/equatable.dart';

class RouteFilterState extends Equatable {
  final bool isPlanned;
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
  final String sortField;

  final int maxLength = 50;
  final int maxSpeed = 100;
  final int maxElevation = 10000;
  final int maxMovingTime = 24;

  const RouteFilterState(
      {required this.isPlanned,
      this.fromDate,
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
      this.sortField = "Date"})
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
  }) {
    return RouteFilterState(
        isPlanned: isPlanned,
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
        sortField: sortField ?? this.sortField);
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
