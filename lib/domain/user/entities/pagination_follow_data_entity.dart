import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaginationFollowDataEntity {
  final int? totalCount;
  final int? pageNumber;
  final int? pageSize;
  final bool? hasPreviousPage;
  final bool? hasNextPage;
  PaginationFollowDataEntity({
    this.totalCount,
    this.pageNumber,
    this.pageSize,
    this.hasPreviousPage,
    this.hasNextPage,
  });
}
