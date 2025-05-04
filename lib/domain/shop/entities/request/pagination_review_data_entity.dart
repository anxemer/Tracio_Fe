import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class PaginationReviewDataEntity {
  final int? totalComments;
  final int? pageSize;
  final int? pageNumber;
  PaginationReviewDataEntity({
    this.totalComments,
    this.pageSize,
    this.pageNumber,
  });
}
