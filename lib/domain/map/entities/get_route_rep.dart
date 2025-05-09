import 'package:Tracio/domain/map/entities/route.dart';

class GetRouteResponseEntity {
  final List<RouteEntity> routes;
  final int? pageNumber;
  final int? pageSize;
  final int? totalRoutes;
  final int? totalPages;
  GetRouteResponseEntity({
    required this.routes,
    this.pageNumber,
    this.pageSize,
    this.totalRoutes,
    this.totalPages,
  });
}
