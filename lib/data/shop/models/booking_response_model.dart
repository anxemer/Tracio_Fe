import 'package:Tracio/data/shop/models/booking_model.dart';
import 'package:Tracio/data/shop/models/pagination_booking_data_model.dart';
import 'package:Tracio/domain/shop/entities/response/booking_response_entity.dart';

class BookingResponseModel extends BookingResponseEntity {
  BookingResponseModel(
      {required super.booking,
      required super.bookingOverlap,
      required super.pagination});

  // Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'booking': booking.map((x) => x.toMap()).toList(),
  //     'bookingOverlap': bookingOverlap.map((x) => x.toMap()).toList(),
  //     'pagination': pagination.toMap(),
  //   };
  // }

  factory BookingResponseModel.fromMap(Map<String, dynamic> map) {
    return BookingResponseModel(
      booking: map['bookings'] != null
          ? List<BookingModel>.from(map['bookings']
              .map((x) => BookingModel.fromJson(x as Map<String, dynamic>)))
          : [],
      bookingOverlap: map['overlappingBookings'] != null
          ? List<BookingModel>.from(
              (map['overlappingBookings'] as List<dynamic>)
                  .expand((e) => e as List<dynamic>)
                  .map((x) => BookingModel.fromJson(x as Map<String, dynamic>)))
          : [],
      pagination: PaginationBookingDataModel.fromMap(map),
    );
  }
}
