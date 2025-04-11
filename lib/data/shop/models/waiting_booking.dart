// ignore_for_file: public_member_api_docs, sort_constructors_first
class WaitingModel {
  WaitingModel({
    required this.bookedDate,
    required this.estimatedEndDate,
    required this.userNote,
    required this.shopNote,
    required this.reason,
    required this.price,
    this.bookingId,
  });

  final DateTime? bookedDate;
  final DateTime? estimatedEndDate;
  final String? userNote;
  final String? shopNote;
  final String? reason;
  final int? price;
  final int? bookingId;

  WaitingModel copyWith({
    DateTime? bookedDate,
    DateTime? estimatedEndDate,
    String? userNote,
    String? shopNote,
    String? reason,
    int? price,
    int? bookingId,
  }) {
    return WaitingModel(
      bookedDate: bookedDate ?? this.bookedDate,
      estimatedEndDate: estimatedEndDate ?? this.estimatedEndDate,
      userNote: userNote ?? this.userNote,
      shopNote: shopNote ?? this.shopNote,
      reason: reason ?? this.reason,
      price: price ?? this.price,
      bookingId: bookingId ?? this.bookingId,
    );
  }

  factory WaitingModel.fromJson(Map<String, dynamic> json) {
    return WaitingModel(
      bookedDate: DateTime.tryParse(json["bookedDate"] ?? ""),
      estimatedEndDate: DateTime.tryParse(json["estimatedEndDate"] ?? ""),
      userNote: json["userNote"],
      shopNote: json["shopNote"],
      reason: json["reason"],
      price: json["price"],
      bookingId: json["bookingId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "bookedDate": bookedDate?.toIso8601String(),
        "estimatedEndDate": estimatedEndDate?.toIso8601String(),
        "userNote": userNote,
        "shopNote": shopNote,
        "reason": reason,
        "price": price,
        "bookingId": bookingId,
      };
}
