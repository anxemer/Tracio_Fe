import 'package:tracio_fe/data/groups/models/response/get_group_route_rep.dart';

class GetGroupRouteListRep {
  final List<GetGroupRouteRep> groupList;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;

  GetGroupRouteListRep({
    required this.groupList,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory GetGroupRouteListRep.fromMap(Map<String, dynamic> map) {
    return GetGroupRouteListRep(
      groupList: List<GetGroupRouteRep>.from(
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
