class GetServiceReqEntity {
   final int? categoryId;
  final String? status;
  final String? keyword;
  final int? shopId;
  final double? distance;
  final String? city;
  final String? district;
  final double? latitude;
  final double? longitude;
  final bool isAscending;
  final int pageSizeService;
  final int pageNumberService;
  final int pageSizeShop;
  final int pageNumberShop;

  GetServiceReqEntity({
    this.categoryId,
    this.status,
    this.keyword,
    this.shopId,
    this.distance,
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
}