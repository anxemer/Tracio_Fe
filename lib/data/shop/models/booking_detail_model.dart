import 'package:tracio_fe/domain/shop/entities/response/booking_detail_entity.dart';

import '../../../common/helper/schedule_model.dart';

class BookingDetailModel extends BookingDetailEntity {
  BookingDetailModel(
      {super.bookingId,
      super.bookingDetailId,
      super.shopId,
      super.shopName,
      super.profilePicture,
      super.contactNumber,
      super.city,
      super.district,
      super.address,
      super.openTime,
      super.closeTime,
      super.isOverlap,
      super.isReviewed,
      super.serviceId,
      super.serviceName,
      super.bookedDate,
      super.estimatedEndDate,
      super.shopCancelledReason,
      super.userCancelledReason,
      super.duration,
      super.status,
      super.userNote,
      super.adjustPriceReason,
      super.shopNote,
      super.price,
      super.serviceMediaFile,
      super.userDayFrees});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookingId': bookingId,
      'bookingDetailId': bookingDetailId,
      'shopId': shopId,
      'shopName': shopName,
      'profilePicture': profilePicture,
      'serviceId': serviceId,
      'serviceName': serviceName,
      'bookedDate': bookedDate?.millisecondsSinceEpoch,
      'estimatedEndDate': estimatedEndDate?.millisecondsSinceEpoch,
      'userCancelledReason': userCancelledReason,
      'shopCancelledReason': shopCancelledReason,
      'duration': duration,
      'status': status,
      'userNote': userNote,
      'adjustPriceReason': adjustPriceReason,
      'shopNote': shopNote,
      'price': price,
      'serviceMediaFile': serviceMediaFile,
      'userDayFrees': userDayFrees?.map((x) => x?.toMap()).toList(),
    };
  }

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailModel(
      bookingId: json['bookingId'] != null ? json['bookingId'] as int : null,
      bookingDetailId: json['bookingDetailId'] != null
          ? json['bookingDetailId'] as int
          : null,
      shopId: json['shopId'] != null ? json['shopId'] as int : null,
      shopName: json['shopName'] != null ? json['shopName'] as String : null,
      profilePicture: json['profilePicture'] != null
          ? json['profilePicture'] as String
          : null,
      serviceId: json['serviceId'] != null ? json['serviceId'] as int : null,
      serviceName:
          json['serviceName'] != null ? json['serviceName'] as String : null,
      bookedDate: DateTime.tryParse(json["bookedDate"] ?? ""),
      estimatedEndDate: DateTime.tryParse(json["estimatedEndDate"] ?? ""),
      shopCancelledReason: json['shopCancelledReason'] != null
          ? json['shopCancelledReason'] as String
          : null,
      userCancelledReason: json['userCancelledReason'] != null
          ? json['userCancelledReason'] as String
          : null,
      duration: json['duration'] != null ? json['duration'] as int : null,
      status: json['status'] != null ? json['status'] as String : null,
      userNote: json['userNote'] != null ? json['userNote'] as String : null,
      adjustPriceReason: json['adjustPriceReason'] != null
          ? json['adjustPriceReason'] as String
          : null,
      shopNote: json['shopNote'] != null ? json['shopNote'] as String : "",
      isOverlap: json["isOverlap"],
      isReviewed: json["isReviewed"],
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      serviceMediaFile: json['serviceMediaFile'] != null
          ? json['serviceMediaFile'] as String
          : null,
      contactNumber: json["contactNumber"],
      city: json["city"],
      district: json["district"],
      address: json["address"],
      openTime: json["openTime"],
      closeTime: json["closeTime"],
      userDayFrees: json['userDayFrees'] != null
          ? List<ScheduleModel>.from(
              (json['userDayFrees'] as List<dynamic>).map(
                (x) => ScheduleModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }
}
