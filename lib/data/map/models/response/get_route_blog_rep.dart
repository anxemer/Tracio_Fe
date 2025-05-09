import 'package:Tracio/data/map/models/route_blog.dart';

class GetRouteBlogRep {
  final List<RouteBlogModel> routeBlogs;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPage;
  final bool hasPreviousPage;
  final bool hasNextPage;
  GetRouteBlogRep({
    required this.routeBlogs,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPage,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  GetRouteBlogRep copyWith({
    List<RouteBlogModel>? routeBlogs,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPage,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return GetRouteBlogRep(
      routeBlogs: routeBlogs ?? this.routeBlogs,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPage: totalPage ?? this.totalPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  factory GetRouteBlogRep.fromMap(Map<String, dynamic> map) {
    return GetRouteBlogRep(
      routeBlogs: List<RouteBlogModel>.from(
        (map['routes']).map<RouteBlogModel>(
          (x) => RouteBlogModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalCount: map['totalRoute'] as int,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalPage: map['totalPage'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
    );
  }
}
