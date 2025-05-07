import 'package:Tracio/domain/groups/entities/group_route.dart';

class GetRouteDetailRep {
  final List<GroupRouteDetail> groupRouteDetails;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;
  GetRouteDetailRep({
    required this.groupRouteDetails,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory GetRouteDetailRep.fromMap(Map<String, dynamic> map) {
    return GetRouteDetailRep(
      groupRouteDetails: List<GroupRouteDetail>.from(
        (map['items']).map<GroupRouteDetail>(
          (x) => GroupRouteDetail.fromMap(x as Map<String, dynamic>),
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
