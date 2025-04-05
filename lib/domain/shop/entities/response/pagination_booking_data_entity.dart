import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaginationBookingDataEntity {
     final int? totalBookings;
    final int? totalPages;
    final int? pageNumber;
    final int? pageSize;
    final bool? hasNextPage;
    final bool? hasPreviousPage;
  PaginationBookingDataEntity({
    this.totalBookings,
    this.totalPages,
    this.pageNumber,
    this.pageSize,
    this.hasNextPage,
    this.hasPreviousPage,
  });


 


}
