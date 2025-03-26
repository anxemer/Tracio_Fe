import 'package:tracio_fe/domain/shop/entities/shop_entity.dart';

class ShopModel extends ShopEntity {
  ShopModel(
      {required super.shopId,
      required super.shopName,
      required super.profilePicture,
      required super.city,
      required super.district,
      required super.address});

  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      shopId: json["shopId"],
      shopName: json["shopName"],
      profilePicture: json["profilePicture"],
      city: json["city"],
      district: json["district"],
      address: json["address"],
    );
  }
  Map<String, dynamic> toJson() => {
        "shopId": shopId,
        "shopName": shopName,
        "profilePicture": profilePicture,
        "city": city,
        "district": district,
        "address": address,
      };
}
