import 'package:Tracio/domain/shop/entities/response/booking_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.bookingId,
    required super.bookingDetailId,
    required super.serviceName,
    required super.serviceMediaFile,
    required super.shopName,
    required super.bookedDate,
    required super.duration,
    required super.estimatedEndDate,
    required super.status,
    required super.price,
    required super.cyclistName,
    required super.cyclistAvatar,
  });
  //  Map<String, dynamic> toMap() {
  //   return <String, dynamic>{
  //     'bookingId': bookingId,
  //     'serviceName': serviceName,
  //     'receivedAt': receivedAt?.millisecondsSinceEpoch,
  //     'serviceMediaFile': serviceMediaFile.map((x) => x.toJson()).toList(),
  //     'shopName': shopName,
  //     'profilePicture': profilePicture,
  //     'bookedDate': bookedDate?.millisecondsSinceEpoch,
  //     'duration': duration,
  //     'estimatedEndDate': estimatedEndDate?.millisecondsSinceEpoch,
  //     'status': status,
  //     'userNote': userNote,
  //     'shopNote': shopNote,
  //     'price': price,
  //   };
  // }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json["bookingId"],
      bookingDetailId: json["bookingDetailId"],
      serviceName: json["serviceName"],
      serviceMediaFile: json["serviceMediaFile"],
      shopName: json["shopName"],
      cyclistName: json["cyclistName"],
      cyclistAvatar: json["cyclistAvatar"],
      bookedDate: DateTime.tryParse(json["bookedDate"] ?? ""),
      duration: json["duration"],
      estimatedEndDate: DateTime.tryParse(json["estimatedEndDate"] ?? ""),
      status: json["status"],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "bookingId": bookingId,
        "bookingDetailId": bookingDetailId,
        "serviceName": serviceName,
        "serviceMediaFile": serviceMediaFile,
        "shopName": shopName,
        "cyclistName": cyclistName,
        "cyclistAvatar": cyclistAvatar,
        "bookedDate": bookedDate?.toIso8601String(),
        "duration": duration,
        "estimatedEndDate": estimatedEndDate?.toIso8601String(),
        "status": status,
        "price": price,
      };
}
