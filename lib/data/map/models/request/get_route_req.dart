// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetRouteReq {
  final int pageNumber;
  final int rowsPerPage;
  final String? sortField;
  final bool? sortAsc;
  final String? searchName;
  final int? minDistance;
  final int? maxDistance;
  final int? minElevation;
  final int? maxElevation;
  final int? minMovingTime;
  final int? maxMovingTime;
  final int? minAvgSpeed;
  final int? maxAvgSpeed;
  final String? isPlanned;
  final double? startLat;
  final double? startLng;
  int? userId;
  GetRouteReq({
    required this.pageNumber,
    required this.rowsPerPage,
    this.sortField,
    this.sortAsc,
    this.searchName,
    this.minDistance,
    this.maxDistance,
    this.minElevation,
    this.maxElevation,
    this.minMovingTime,
    this.maxMovingTime,
    this.minAvgSpeed,
    this.maxAvgSpeed,
    this.isPlanned,
    this.startLat,
    this.startLng,
    this.userId,
  });

  GetRouteReq copyWith({
    int? pageNumber,
    int? rowsPerPage,
    String? sortField,
    bool? sortAsc,
    String? searchName,
    int? minDistance,
    int? maxDistance,
    int? minElevation,
    int? maxElevation,
    int? minMovingTime,
    int? maxMovingTime,
    int? minAvgSpeed,
    int? maxAvgSpeed,
    String? isPlanned,
    double? startLat,
    double? startLng,
    int? userId,
  }) {
    return GetRouteReq(
      pageNumber: pageNumber ?? this.pageNumber,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      sortField: sortField ?? this.sortField,
      sortAsc: sortAsc ?? this.sortAsc,
      searchName: searchName ?? this.searchName,
      minDistance: minDistance ?? this.minDistance,
      maxDistance: maxDistance ?? this.maxDistance,
      minElevation: minElevation ?? this.minElevation,
      maxElevation: maxElevation ?? this.maxElevation,
      minMovingTime: minMovingTime ?? this.minMovingTime,
      maxMovingTime: maxMovingTime ?? this.maxMovingTime,
      minAvgSpeed: minAvgSpeed ?? this.minAvgSpeed,
      maxAvgSpeed: maxAvgSpeed ?? this.maxAvgSpeed,
      isPlanned: isPlanned ?? this.isPlanned,
      startLat: startLat ?? this.startLat,
      startLng: startLng ?? this.startLng,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pageNumber': pageNumber,
      'rowsPerPage': rowsPerPage,
      'sortField': sortField,
      'sortAsc': sortAsc,
      'searchName': searchName,
      'minDistance': minDistance,
      'maxDistance': maxDistance,
      'minElevation': minElevation,
      'maxElevation': maxElevation,
      'minMovingTime': minMovingTime,
      'maxMovingTime': maxMovingTime,
      'minAvgSpeed': minAvgSpeed,
      'maxAvgSpeed': maxAvgSpeed,
      'isPlanned': isPlanned,
      'startLat': startLat,
      'startLng': startLng,
      'userId': userId,
    };
  }

  factory GetRouteReq.fromMap(Map<String, dynamic> map) {
    return GetRouteReq(
      pageNumber: map['pageNumber'] as int,
      rowsPerPage: map['rowsPerPage'] as int,
      sortField: map['sortField'] != null ? map['sortField'] as String : null,
      sortAsc: map['sortAsc'] != null ? map['sortAsc'] as bool : null,
      searchName: map['searchName'] as String,
      minDistance: map['minDistance'] as int,
      maxDistance: map['maxDistance'] as int,
      minElevation: map['minElevation'] as int,
      maxElevation: map['maxElevation'] as int,
      minMovingTime: map['minMovingTime'] as int,
      maxMovingTime: map['maxMovingTime'] as int,
      minAvgSpeed: map['minAvgSpeed'] as int,
      maxAvgSpeed: map['maxAvgSpeed'] as int,
      isPlanned: map['isPlanned'] as String,
      startLat: map['startLat'] as double,
      startLng: map['startLng'] as double,
      userId: map['userId'] != null ? map['userId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetRouteReq.fromJson(String source) =>
      GetRouteReq.fromMap(json.decode(source) as Map<String, dynamic>);
  Map<String, String> toQueryParams() {
    final Map<String, String> queryParams = {
      'pageNumber': pageNumber.toString(),
      'rowsPerPage': rowsPerPage.toString(),
    };

    void addIfNotNull(String key, dynamic value) {
      if (value != null) {
        queryParams[key] = value.toString();
      }
    }

    addIfNotNull('sortField', sortField);
    addIfNotNull('sortAsc', sortAsc);
    addIfNotNull('searchName', searchName);
    addIfNotNull('minDistance', minDistance);
    addIfNotNull('maxDistance', maxDistance);
    addIfNotNull('minElevation', minElevation);
    addIfNotNull('maxElevation', maxElevation);
    addIfNotNull('minMovingTime', minMovingTime);
    addIfNotNull('maxMovingTime', maxMovingTime);
    addIfNotNull('minAvgSpeed', minAvgSpeed);
    addIfNotNull('maxAvgSpeed', maxAvgSpeed);
    addIfNotNull('isPlanned', isPlanned);
    addIfNotNull('startLat', startLat);
    addIfNotNull('startLng', startLng);
    addIfNotNull('userId', userId);

    return queryParams;
  }

  @override
  String toString() {
    return 'GetRouteReq(pageNumber: $pageNumber, rowsPerPage: $rowsPerPage, sortField: $sortField, sortAsc: $sortAsc, searchName: $searchName, minDistance: $minDistance, maxDistance: $maxDistance, minElevation: $minElevation, maxElevation: $maxElevation, minMovingTime: $minMovingTime, maxMovingTime: $maxMovingTime, minAvgSpeed: $minAvgSpeed, maxAvgSpeed: $maxAvgSpeed, isPlanned: $isPlanned, startLat: $startLat, startLng: $startLng, userId: $userId)';
  }

  @override
  bool operator ==(covariant GetRouteReq other) {
    if (identical(this, other)) return true;

    return other.pageNumber == pageNumber &&
        other.rowsPerPage == rowsPerPage &&
        other.sortField == sortField &&
        other.sortAsc == sortAsc &&
        other.searchName == searchName &&
        other.minDistance == minDistance &&
        other.maxDistance == maxDistance &&
        other.minElevation == minElevation &&
        other.maxElevation == maxElevation &&
        other.minMovingTime == minMovingTime &&
        other.maxMovingTime == maxMovingTime &&
        other.minAvgSpeed == minAvgSpeed &&
        other.maxAvgSpeed == maxAvgSpeed &&
        other.isPlanned == isPlanned &&
        other.startLat == startLat &&
        other.startLng == startLng &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return pageNumber.hashCode ^
        rowsPerPage.hashCode ^
        sortField.hashCode ^
        sortAsc.hashCode ^
        searchName.hashCode ^
        minDistance.hashCode ^
        maxDistance.hashCode ^
        minElevation.hashCode ^
        maxElevation.hashCode ^
        minMovingTime.hashCode ^
        maxMovingTime.hashCode ^
        minAvgSpeed.hashCode ^
        maxAvgSpeed.hashCode ^
        isPlanned.hashCode ^
        startLat.hashCode ^
        startLng.hashCode ^
        userId.hashCode;
  }
}
