class PaginationServiceDataEntity {
  PaginationServiceDataEntity({
     this.totalShops,
     this.totalServices,
     this.pageSizeService,
     this.pageNumberService,
     this.pageSizeShop,
     this.pageNumberShop,
  });

  final int? totalShops;
  final int? totalServices;
  final int? pageSizeService;
  final int? pageNumberService;
  final int? pageSizeShop;
  final int? pageNumberShop;
}
