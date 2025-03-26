import 'dart:convert';

import 'package:tracio_fe/domain/shop/entities/shop_service_entity.dart';

class ShopServiceModel extends ShopServiceEntity {
  ShopServiceModel(
      {required super.serviceId,
      required super.shopId,
      required super.shopName,
      required super.profilePicture,
      required super.city,
      required super.district,
      required super.address,
      required super.name,
      required super.description,
      required super.price,
      required super.status,
      required super.duration,
      required super.serviceSlots,
      required super.mediaFiles});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'serviceId': serviceId,
      'shopId': shopId,
      'shopName': shopName,
      'profilePicture': profilePicture,
      'city': city,
      'district': district,
      'address': address,
    'serviceName': name,
      'description': description,
      'price': price,
      'status': status,
      'duration': duration,
      'serviceSlots': serviceSlots,
      'mediaFiles': mediaFiles,
    };
  }

  factory ShopServiceModel.fromMap(Map<String, dynamic> map) {
    return ShopServiceModel(
        serviceId: map['serviceId'] != null ? map['serviceId'] as int : null,
        shopId: map['shopId'] != null ? map['shopId'] as int : null,
        shopName: map['shopName'] != null ? map['shopName'] as String : null,
        profilePicture: map['profilePicture'] != null
            ? map['profilePicture'] as String
            : null,
        city: map['city'] != null ? map['city'] as String : null,
        district: map['district'] != null ? map['district'] as String : null,
        address: map['address'] != null ? map['address'] as String : null,
        name: map['serviceName'] != null ? map['serviceName'] as String : null,
        description:
            map['description'] != null ? map['description'] as String : null,
        price: map['price'] != null ? map['price'] as double : null,
        status: map['status'] != null ? map['status'] as String : null,
        duration: map['duration'] != null ? map['duration'] as int : null,
        serviceSlots: map['serviceSlots'] as dynamic,
        mediaFiles: List<dynamic>.from(
          (map['mediaFiles'] as List<dynamic>),
        ));
  }
}
