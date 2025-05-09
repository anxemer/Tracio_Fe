import 'package:Tracio/domain/shop/entities/response/shop_profile_entity.dart';

class ShopProfileModel extends ShopProfileEntity {
  ShopProfileModel(
      {required super.shopId,
      required super.ownerId,
      required super.taxCode,
      required super.shopName,
      required super.profilePicture,
      required super.coordinate,
      required super.contactNumber,
      required super.openTime,
      required super.closedTime,
      required super.isActive,
      required super.totalBooking,
      required super.totalService,
      required super.totalPendingBooking,
      required super.city,
      required super.district,
      required super.address});

  factory ShopProfileModel.fromJson(Map<String, dynamic> json) {
    return ShopProfileModel(
      shopId: json["shopId"],
      ownerId: json["ownerId"],
      taxCode: json["taxCode"],
      shopName: json["shopName"],
      profilePicture: json["profilePicture"],
      coordinate: json["coordinate"] == null
          ? null
          : CoordinateModel.fromJson(json["coordinate"]),
      contactNumber: json["contactNumber"],
      openTime: json["openTime"],
      closedTime: json["closedTime"],
      isActive: json["isActive"],
      totalBooking: json["totalBooking"],
      city: json["city"],
      district: json["district"],
      address: json["address"],
      totalPendingBooking: json["totalPendingBooking"],
      totalService: json["totalPendingBooking"],
    );
  }

// Map<String, dynamic> toJson() => {
//     "shopId": shopId,
//     "ownerId": ownerId,
//     "taxCode": taxCode,
//     "shopName": shopName,
//     "profilePicture": profilePicture,
//     "coordinate": coordinate?.toJson(),
//     "contactNumber": contactNumber,
//     "openTime": openTime,
//     "closedTime": closedTime,
//     "isActive": isActive,
//     "totalBooking": totalBooking,
//     "city": city,
//     "district": district,
//     "address": address,
// };
}

class CoordinateModel extends CoordinateEntity {
  CoordinateModel({required super.longitude, required super.latitude});

  CoordinateEntity copyWith({
    double? longitude,
    double? latitude,
  }) {
    return CoordinateEntity(
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }

  factory CoordinateModel.fromJson(Map<String, dynamic> json) {
    return CoordinateModel(
      longitude: json["longitude"],
      latitude: json["latitude"],
    );
  }

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
      };
}
