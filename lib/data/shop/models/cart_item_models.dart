import 'package:tracio_fe/domain/shop/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  CartItemModel({
    required super.itemId,
    required super.bookingQueueId,
    required super.serviceId,
    required super.shopId,
    required super.shopName,
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
      price: json["price"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "bookingQueueId": bookingQueueId,
        "serviceId": serviceId,
        "shopId": shopId,
        "shopName": shopName,
        "serviceName": serviceName,
        "price": price,
        "createdAt": createdAt?.toIso8601String(),
      };
}
