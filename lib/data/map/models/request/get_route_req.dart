class GetRouteReq {
  final int pageNumber;
  final int pageSize;
  final String?
      sortField; //RouteName, City, TotalDistance, ElevationGain, MovingTime, DurationTime, AvgSpeed, MaxSpeed, ReactionCounts, ReviewCounts, CreatedAt, UpdatedAt
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
    required this.pageSize,
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
    int? pageSize,
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
      pageSize: pageSize ?? this.pageSize,
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

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    };

    if (sortField != null) params['sortField'] = sortField!;
    if (sortAsc != null) params['sortAsc'] = sortAsc.toString();
    if (searchName != null && searchName!.isNotEmpty) {
      params['searchName'] = searchName!;
    }
    if (minDistance != null) params['minDistance'] = minDistance.toString();
    if (maxDistance != null) params['maxDistance'] = maxDistance.toString();
    if (minElevation != null) params['minElevation'] = minElevation.toString();
    if (maxElevation != null) params['maxElevation'] = maxElevation.toString();
    if (minMovingTime != null) {
      params['minMovingTime'] = minMovingTime.toString();
    }
    if (maxMovingTime != null) {
      params['maxMovingTime'] = maxMovingTime.toString();
    }
    if (minAvgSpeed != null) params['minAvgSpeed'] = minAvgSpeed.toString();
    if (maxAvgSpeed != null) params['maxAvgSpeed'] = maxAvgSpeed.toString();
    if (isPlanned != null) params['isPlanned'] = isPlanned!;
    if (startLat != null) params['startLat'] = startLat.toString();
    if (startLng != null) params['startLng'] = startLng.toString();
    if (userId != null) params['userId'] = userId.toString();

    return params;
  }
}
