import 'dart:convert';

import 'package:tracio_fe/data/map/models/route.dart';
import 'package:tracio_fe/domain/map/entities/route.dart';

class GetRouteRepModel {
  final List<RouteEntity> routes;
  final int? pageNumber;
  final int? pageSize;
  final int? totalRoutes;
  final int? totalPages;
  GetRouteRepModel({
    required this.routes,
    this.pageNumber,
    this.pageSize,
    this.totalRoutes,
    this.totalPages,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'routes': routes.map((x) => x.toMap()).toList(),
      // 'pageNumber': pageNumber?.toMap(),
      // 'pageSize': pageSize?.toMap(),
      // 'totalRoutes': totalRoutes?.toMap(),
      // 'totalPages': totalPages?.toMap(),
    };
  }

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
      totalRoutes: resultMap['totalCount'],
      totalPages: resultMap['totalPages'],
    );
  }

  String toJson() => json.encode(toMap());
}
