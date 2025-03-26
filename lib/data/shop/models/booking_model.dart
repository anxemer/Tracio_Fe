import 'package:tracio_fe/domain/shop/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.bookingId,
    required super.serviceName,
    required super.bookedDate,
    required super.status,
    required super.userNote,
    required super.shopNote,
    required super.price,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json["bookingId"],
      serviceName: json["serviceName"],
      bookedDate: DateTime.tryParse(json["bookedDate"] ?? ""),
      status: json["status"],
      userNote: json["userNote"],
      shopNote: json["shopNote"],
      price: json["price"],
    );
  }
}
