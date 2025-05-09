import 'package:Tracio/data/map/models/route.dart';
import 'package:Tracio/domain/map/entities/route.dart';

class GetRouteRepModel extends RoutePaginationEntity {
  GetRouteRepModel({
    required super.routes,
    required super.pageNumber,
    required super.pageSize,
    required super.totalCount,
    required super.totalPages,
    required super.hasPreviousPage,
    required super.hasNextPage,
  });

  factory GetRouteRepModel.fromMap(Map<String, dynamic> map) {
    final resultMap = map['result'];
    if (resultMap == null) {
      throw FormatException("Missing 'result' field in API response");
    }

    final List<dynamic> routesList = resultMap['items'];
    return GetRouteRepModel(
      routes: List<RouteEntity>.from(
          routesList.map((x) => RouteModel.fromMap(x as Map<String, dynamic>))),
      pageNumber: resultMap['pageNumber'],
      pageSize: resultMap['pageSize'],
      totalCount: resultMap['totalCount'],
      totalPages: resultMap['totalPages'],
      hasPreviousPage: resultMap['hasPreviousPage'],
      hasNextPage: resultMap['hasNextPage'],
    );
  }
}
