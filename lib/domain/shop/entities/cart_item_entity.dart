class CartItemEntity {
  CartItemEntity({
    required this.itemId,
    required this.bookingQueueId,
    required this.serviceId,
    required this.shopId,
    required this.shopName,
    required this.serviceName,
    required this.price,
    required this.createdAt,
  });

  final int? itemId;
  final int? bookingQueueId;
  final int? serviceId;
  final int? shopId;
  final String? shopName;
  final String? serviceName;
  final double? price;
  final DateTime? createdAt;
}
