import 'dart:convert';

import 'package:tracio_fe/domain/shop/entities/response/shop_service_entity.dart';

import '../../../common/helper/media_file.dart';

class ShopServiceModel extends ShopServiceEntity {
  ShopServiceModel(
      {super.serviceId,
      super.shopId,
      super.shopName,
      super.categoryName,
      super.profilePicture,
      super.city,
      super.district,
      super.serviceName,
      super.description,
      super.price,
      super.status,
      super.totalBookings,
      super.avgRating,
      super.duration,
      super.totalReviews,
      super.distance,
      super.mediaFiles,
      super.closeTime,
      super.openTime});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serviceId': serviceId,
      'shopId': shopId,
      'shopName': shopName,
      'openTime': openTime,
      'closeTime': closeTime,
      'categoryName': categoryName,
      'profilePicture': profilePicture,
      'city': city,
      'district': district,
      'serviceName': serviceName,
      'description': description,
      'price': price,
      'status': status,
      'totalBookings': totalBookings,
      'avgRating': avgRating,
      'duration': duration,
      'totalReviews': totalReviews,
      'distance': distance,
      'mediaFiles': mediaFiles?.map((x) => x).toList(),
    };
  }

  factory ShopServiceModel.fromMap(Map<String, dynamic> map) {
    return ShopServiceModel(
      serviceId: map['serviceId'] != null ? map['serviceId'] as int : null,
      shopId: map['shopId'] != null ? map['shopId'] as int : null,
      shopName: map['shopName'] != null ? map['shopName'] as String : null,
      openTime: map['openTime'] != null ? map['openTime'] as String : null,
      closeTime: map['closeTime'] != null ? map['closeTime'] as String : null,
      categoryName:
          map['categoryName'] != null ? map['categoryName'] as String : null,
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] as String
          : null,
      city: map['city'] != null ? map['city'] as String : null,
      district: map['district'] != null ? map['district'] as String : null,
      serviceName:
          map['serviceName'] != null ? map['serviceName'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      price: map['price'] != null ? map['price'] as double : null,
      status: map['status'] != null ? map['status'] as String : null,
      totalBookings:
          map['totalBookings'] != null ? map['totalBookings'] as int : null,
      avgRating: map['avgRating'] != null ? map['avgRating'] as int : null,
      duration: map['duration'] != null ? map['duration'] as int : null,
      totalReviews:
          map['totalReviews'] != null ? map['totalReviews'] as int : null,
      distance: map['distance'] != null ? map['distance'] as double : null,
      mediaFiles: map["mediaFiles"] == null
          ? []
          : List<MediaFile>.from(map["mediaFiles"]!.map((x) => x)),
    );
  }

  // String toJson() => json.encode(toMap());

  // factory ShopServiceModel.fromJson(String source) => ShopServiceEntity.fromMap(json.decode(source) as Map<String, dynamic>);
  // factory ShopServiceModel.fromJson(Map<String, dynamic> json) {
  //   return ShopServiceModel(
  //     serviceId: json["serviceId"],
  //     shopId: json["shopId"],
  //     shopName: json["shopName"],
  //     categoryName: json["categoryName"],
  //     profilePicture: json["profilePicture"],
  //     city: json["city"],
  //     district: json["district"],
  //     serviceName: json["serviceName"],
  //     description: json["description"],
  //     price: json["price"],
  //     status: json["status"],
  //     totalBookings: json["totalBookings"],
  //     avgRating: json["avgRating"],
  //     duration: json["duration"],
  //     totalReviews: json["totalReviews"],
  //     distance: json["distance"],
  //     mediaFiles: json["mediaFiles"] == null
  //         ? []
  //         : List<MediaFile>.from(json["mediaFiles"]!.map((x) => x)),
  //   );
  // }

  // Map<String, dynamic> toJson() => {
  //       "serviceId": serviceId,
  //       "shopId": shopId,
  //       "shopName": shopName,
  //       "categoryName": categoryName,
  //       "profilePicture": profilePicture,
  //       "city": city,
  //       "district": district,
  //       "serviceName": serviceName,
  //       "description": description,
  //       "price": price,
  //       "status": status,
  //       "totalBookings": totalBookings,
  //       "avgRating": avgRating,
  //       "duration": duration,
  //       "totalReviews": totalReviews,
  //       "distance": distance,
  //       "mediaFiles": mediaFiles?.map((x) => x).toList(),
  //     };
  // String toJson() => json.encode(toMap());
}
