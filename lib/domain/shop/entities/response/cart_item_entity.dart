// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:intl/intl.dart';

class CartItemEntity {
  CartItemEntity({
    this.itemId,
    this.bookingQueueId,
    this.serviceId,
    this.shopId,
    this.duration,
    this.city,
    this.district,
    this.shopName,
    this.serviceName,
    this.openTime,
    this.closeTime,
    this.mediaUrl,
    this.price,
    this.createdAt,
    this.serviceStatus,
    this.shopStatus,
  });

  final int? itemId;
  final int? bookingQueueId;
  final int? serviceId;
  final int? shopId;
  final int? duration;
  final String? city;
  final String? district;
  final String? shopName;
  final String? serviceName;
  final String? openTime;
  final String? closeTime;
  final String? mediaUrl;
  final double? price;
  final DateTime? createdAt;
  final String? serviceStatus;
  final String? shopStatus;

  String get formattedDuration {
    int totalMinutes = duration!;

    if (totalMinutes >= 60) {
      int hours = totalMinutes ~/ 60;
      int remainingMinutes = totalMinutes % 60;

      if (remainingMinutes > 0) {
        return "$hours hour $remainingMinutes minutes";
      } else {
        return "$hours hour";
      }
    } else if (totalMinutes > 0) {
      return "$totalMinutes minutes";
    } else {
      return "0 minutes"; // Trường hợp duration = 0
    }
  }

  String get formattedPrice {
    double priceAsInt = price!.toDouble();

    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(priceAsInt);
  }

  int? get openHour {
    if (openTime == null || !openTime!.contains(':')) return null;
    return int.tryParse(openTime!.split(':')[0]);
  }

  int? get closeHour {
    if (closeTime == null || !closeTime!.contains(':')) return null;
    return int.tryParse(closeTime!.split(':')[0]);
  }
}
