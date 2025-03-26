// ignore_for_file: public_member_api_docs, sort_constructors_first
class BookingEntity {
  final int? bookingId;
  final String? serviceName;
  final DateTime? bookedDate;
  final String? status;
  final String? userNote;
  final String? shopNote;
  final double? price;
  BookingEntity({
    this.bookingId,
    this.serviceName,
    this.bookedDate,
    this.status,
    this.userNote,
    this.shopNote,
    this.price,
  });
}
