import 'package:tracio_fe/domain/shop/entities/response/booking_entity.dart';

import '../../../common/helper/media_file.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.bookingId,
    required super.serviceName,
    required super.receivedAt,
    required super.serviceMediaFile,
    required super.shopName,
    required super.profilePicture,
    required super.bookedDate,
    required super.duration,
    required super.estimatedEndDate,
    required super.status,
    required super.userNote,
    required super.shopNote,
    required super.price,
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

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      bookingId: map['bookingId'] != null ? map['bookingId'] as int : null,
      serviceName:
          map['serviceName'] != null ? map['serviceName'] as String : null,
      receivedAt: map['receivedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['receivedAt'] as int)
          : null,
      serviceMediaFile: map["mediaFiles"] == null
          ? []
          : List<MediaFile>.from(
              map["mediaFiles"]!.map((x) => MediaFile.fromJson(x))),
      shopName: map['shopName'] != null ? map['shopName'] as String : null,
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] as String
          : null,
      bookedDate: DateTime.tryParse(map["bookedDate"] ?? ""),
      duration: map['duration'] != null ? map['duration'] as int : null,
      estimatedEndDate: DateTime.tryParse(map["estimatedEndDate"] ?? ""),
      status: map['status'] != null ? map['status'] as String : null,
      userNote: map['userNote'] != null ? map['userNote'] as String : null,
      shopNote: map['shopNote'] != null ? map['shopNote'] as String : null,
      price: map['price'] != null ? map['price'] as double : null,
    );
  }
}
