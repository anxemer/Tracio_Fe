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
      super.serviceId,
      super.serviceName,
      super.bookedDate,
      super.estimatedEndDate,
      super.reason,
      super.duration,
      super.status,
      super.userNote,
      super.shopNote,
      super.price,
      super.serviceMediaFile,
      super.incidentalCharges,
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
      'reason': reason,
      'duration': duration,
      'status': status,
      'userNote': userNote,
      'shopNote': shopNote,
      'price': price,
      'serviceMediaFile': serviceMediaFile,
      'incidentalCharges': incidentalCharges?.map((x) => x?.toJson()).toList(),
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
      reason: json['reason'] != null ? json['reason'] as String : "",
      duration: json['duration'] != null ? json['duration'] as int : null,
      status: json['status'] != null ? json['status'] as String : null,
      userNote: json['userNote'] != null ? json['userNote'] as String : null,
      shopNote: json['shopNote'] != null ? json['shopNote'] as String : "",
      isOverlap: json["isOverlap"],
      price: json['price'] != null ? json['price'] as double : null,
      serviceMediaFile: json['serviceMediaFile'] != null
          ? json['serviceMediaFile'] as String
          : null,
      contactNumber: json["contactNumber"],
      city: json["city"],
      district: json["district"],
      address: json["address"],
      openTime: json["openTime"],
      closeTime: json["closeTime"],
      incidentalCharges: json['incidentalCharges'] != null
          ? List<IncidentalCharge>.from(
              (json['incidentalCharges'] as List<dynamic>).map(
                (x) => IncidentalCharge.fromJson(x as Map<String, dynamic>),
              ),
            )
          : null,
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

class IncidentalCharge {
  IncidentalCharge({
    required this.chargeId,
    required this.title,
    required this.description,
    required this.price,
    required this.createdAt,
    required this.status,
  });

  final int? chargeId;
  final String? title;
  final String? description;
  final int? price;
  final DateTime? createdAt;
  final dynamic status;

  IncidentalCharge copyWith({
    int? chargeId,
    String? title,
    String? description,
    int? price,
    DateTime? createdAt,
    String? status,
  }) {
    return IncidentalCharge(
      chargeId: chargeId ?? this.chargeId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }

  factory IncidentalCharge.fromJson(Map<String, dynamic> json) {
    return IncidentalCharge(
      chargeId: json["chargeId"],
      title: json["title"],
      description: json["description"],
      price: json["price"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "chargeId": chargeId,
        "title": title,
        "description": description,
        "price": price,
        "createdAt": createdAt?.toIso8601String(),
        "status": status,
      };
}
