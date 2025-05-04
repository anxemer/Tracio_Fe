// ignore_for_file: public_member_api_docs, sort_constructors_first
class ConfirmBookingModel {
  ConfirmBookingModel({
    required this.bookedDate,
    required this.userNote,
    required this.shopNote,
    required this.reason,
    required this.price,
    this.adjustPriceReason,
    this.bookingId,
  });

  final DateTime? bookedDate;
  final String? userNote;
  final String? shopNote;
  final String? reason;
  final String? price;
  final String? adjustPriceReason;
  final int? bookingId;

  ConfirmBookingModel copyWith({
    DateTime? bookedDate,
    String? userNote,
    String? shopNote,
    String? reason,
    String? price,
    String? adjustPriceReason,
    int? bookingId,
  }) {
    return ConfirmBookingModel(
      bookedDate: bookedDate ?? this.bookedDate,
      userNote: userNote ?? this.userNote,
      shopNote: shopNote ?? this.shopNote,
      reason: reason ?? this.reason,
      price: price ?? this.price,
      bookingId: bookingId ?? this.bookingId,
    );
  }

  factory ConfirmBookingModel.fromJson(Map<String, dynamic> json) {
    return ConfirmBookingModel(
      bookedDate: DateTime.tryParse(json["bookedDate"] ?? ""),
      userNote: json["userNote"],
      shopNote: json["shopNote"],
      reason: json["reason"],
      price: json["price"],
      bookingId: json["bookingId"],
    );
  }

  Map<String, dynamic> toJson() {
    print("bookedDate: ${bookedDate?.toIso8601String()}");

    return {
      "bookedDate": bookedDate?.toIso8601String(),
      "userNote": userNote,
      "shopNote": shopNote,
      "reason": reason,
      "readjustPriceReasonason": adjustPriceReason,
      "price": price,
      "bookingId": bookingId,
    };
  }
}
