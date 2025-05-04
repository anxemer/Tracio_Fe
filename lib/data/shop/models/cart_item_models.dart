import 'package:tracio_fe/domain/shop/entities/response/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.itemId,
    required super.bookingQueueId,
    required super.serviceId,
    required super.shopId,
    super.city,
    super.district,
    required super.shopName,
    required super.mediaUrl,
    required super.duration,
    required super.serviceName,
    required super.price,
    required super.createdAt,
  });
  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      itemId: json["itemId"],
      bookingQueueId: json["bookingQueueId"],
      serviceId: json["serviceId"],
      shopId: json["shopId"],
      shopName: json["shopName"],
      serviceName: json["serviceName"],
      city: json['city'] != null ? json['city'] as String : null,
      district: json['district'] != null ? json['district'] as String : null,
      price: json["price"],
      duration: json['duration'] != null ? json['duration'] as int : null,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      mediaUrl: json["mediaUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "bookingQueueId": bookingQueueId,
        "serviceId": serviceId,
        "shopId": shopId,
        'city': city,
        'district': district,
        'duration': duration,
        "shopName": shopName,
        "serviceName": serviceName,
        "price": price,
        "createdAt": createdAt?.toIso8601String(),
      };
}
