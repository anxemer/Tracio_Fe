import 'package:Tracio/data/groups/models/response/get_group_route_rep.dart';
import 'package:Tracio/domain/groups/entities/group_route.dart';

class GetGroupRouteListRep extends GroupRoutePaginationEntity {
  GetGroupRouteListRep({
    required super.groupRouteList,
    required super.totalCount,
    required super.pageNumber,
    required super.pageSize,
    required super.totalPages,
    required super.hasPreviousPage,
    required super.hasNextPage,
  });

  factory GetGroupRouteListRep.fromMap(Map<String, dynamic> map) {
    return GetGroupRouteListRep(
      groupRouteList: List<GetGroupRouteRep>.from(
        (map['items'] as List).map(
          (x) => GetGroupRouteRep.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalCount: map['totalCount'] as int,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalPages: map['totalPages'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
    );
  }
}
