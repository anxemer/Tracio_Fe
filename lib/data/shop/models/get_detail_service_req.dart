class GetDetailServiceReq {
  final int? serviceId;

  final double? latitude;
  final double? longitude;

  GetDetailServiceReq({
    this.serviceId,
    this.latitude,
    this.longitude,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (serviceId != null) data['categoryId'] = serviceId;

    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;

    return data;
  }

  // factory GetServiceReq.fromJson(Map<String, dynamic> json) {
  //   return GetServiceReq(
  //     categoryId: json['categoryId'],
  //     status: json['status'],
  //     keyword: json['keyword'],
  //     shopId: json['shopId'],
  //     distance: json['distance'],
  //     city: json['city'],
  //     district: json['district'],
  //     latitude: json['latitude'],
  //     longitude: json['longitude'],
  //     isAscending: json['isAscending'] ?? true,
  //     pageSizeService: json['pageSizeService'] ?? 10,
  //     pageNumberService: json['pageNumberService'] ?? 1,
  //     pageSizeShop: json['pageSizeShop'] ?? 5,
  //     pageNumberShop: json['pageNumberShop'] ?? 1,
  //   );
  // }
  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};

    // Chỉ thêm các trường không null vào request
    if (serviceId != null) params['categoryId'] = serviceId.toString();

    if (latitude != null) params['latitude'] = latitude.toString();
    if (longitude != null) params['longitude'] = longitude.toString();

    return params;
  }
}
