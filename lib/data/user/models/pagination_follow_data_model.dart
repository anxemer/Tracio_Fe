import 'package:Tracio/domain/user/entities/pagination_follow_data_entity.dart';

class PaginationFollowDataModel extends PaginationFollowDataEntity {
  PaginationFollowDataModel(
      {required super.totalCount,
      required super.pageSize,
      required super.pageNumber,
      required super.hasPreviousPage,
      required super.hasNextPage});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }

  factory PaginationFollowDataModel.fromMap(Map<String, dynamic> map) {
    return PaginationFollowDataModel(
      totalCount: map['totalCount'] != null ? map['totalCount'] as int : null,
      pageNumber: map['pageNumber'] != null ? map['pageNumber'] as int : null,
      pageSize: map['pageSize'] != null ? map['pageSize'] as int : null,
      hasPreviousPage: map['hasPreviousPage'] != null
          ? map['hasPreviousPage'] as bool
          : null,
      hasNextPage:
          map['hasNextPage'] != null ? map['hasNextPage'] as bool : null,
    );
  }
}
