// ignore_for_file: public_member_api_docs, sort_constructors_firs

import 'package:Tracio/domain/shop/entities/response/booking_entity.dart';
import 'package:Tracio/domain/shop/entities/response/pagination_booking_data_entity.dart';

class BookingResponseEntity {
  final List<BookingEntity> booking;
  final List<BookingEntity> bookingOverlap;
  final PaginationBookingDataEntity pagination;
  BookingResponseEntity({
    required this.booking,
    required this.bookingOverlap,
    required this.pagination,
  });
}
