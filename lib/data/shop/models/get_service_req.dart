class GetServiceReq {
  final int? categoryId;
  final String? status;
  final String? keyword;
  final int? shopId;
  final double? distance;
  final double? priceFrom;
  final double? priceTo;
  final String? city;
  final String? district;
  final double? latitude;
  final double? longitude;
  final bool isAscending;
  final int pageSizeService;
  final int pageNumberService;
  final int pageSizeShop;
  final int pageNumberShop;

  GetServiceReq({
    this.categoryId,
    this.status,
    this.keyword,
    this.shopId,
    this.distance,
    this.priceFrom,
    this.priceTo,
    this.city,
    this.district,
    this.latitude,
    this.longitude,
    this.isAscending = true,
    this.pageSizeService = 10,
    this.pageNumberService = 1,
    this.pageSizeShop = 5,
    this.pageNumberShop = 1,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (categoryId != null) data['categoryId'] = categoryId;
    if (status != null) data['status'] = status;
    if (keyword != null) data['keyword'] = keyword;
    if (shopId != null) data['shopId'] = shopId;
    if (distance != null) data['distance'] = distance;
    if (priceFrom != null) data['priceFrom'] = priceFrom;
    if (priceTo != null) data['priceTo'] = priceTo;
    if (city != null) data['city'] = city;
    if (district != null) data['district'] = district;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;

    data['isAscending'] = isAscending;
    data['pageSizeService'] = pageSizeService;
    data['pageNumberService'] = pageNumberService;
    data['pageSizeShop'] = pageSizeShop;
    data['pageNumberShop'] = pageNumberShop;

    return data;
  }

  GetServiceReq copyWith({
    int? categoryId,
    String? status,
    String? keyword,
    int? shopId,
    double? distance,
    double? priceFrom,
    double? priceTo,
    String? city,
    String? district,
    double? latitude,
    double? longitude,
    bool? isAscending,
    int? pageSizeService,
    int? pageNumberService,
    int? pageSizeShop,
    int? pageNumberShop,
  }) {
    return GetServiceReq(
      categoryId: categoryId,
      status: status ?? this.status,
      keyword: keyword ?? this.keyword,
      shopId: shopId ?? this.shopId,
      distance: distance ?? this.distance,
      priceFrom: priceFrom ?? this.priceFrom,
      priceTo: priceTo ?? this.priceTo,
      city: city ?? this.city,
      district: district ?? this.district,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isAscending: isAscending ?? this.isAscending,
      pageSizeService: pageSizeService ?? this.pageSizeService,
      pageNumberService: pageNumberService ?? this.pageNumberService,
      pageSizeShop: pageSizeShop ?? this.pageSizeShop,
      pageNumberShop: pageNumberShop ?? this.pageNumberShop,
    );
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
    if (categoryId != null) params['categoryId'] = categoryId.toString();
    if (status != null) params['status'] = status!;
    if (keyword != null) params['keyword'] = keyword!;
    if (shopId != null) params['shopId'] = shopId.toString();
    if (priceFrom != null) params['priceFrom'] = priceFrom.toString();
    if (priceTo != null) params['priceTo'] = priceTo.toString();
    if (distance != null) params['distance'] = distance.toString();
    if (city != null) params['city'] = city!;
    if (district != null) params['district'] = district!;
    if (latitude != null) params['latitude'] = latitude.toString();
    if (longitude != null) params['longitude'] = longitude.toString();

    params['isAscending'] = isAscending.toString();
    params['pageSizeService'] = pageSizeService.toString();
    params['pageNumberService'] = pageNumberService.toString();
    params['pageSizeShop'] = pageSizeShop.toString();
    params['pageNumberShop'] = pageNumberShop.toString();

    return params;
  }
}
