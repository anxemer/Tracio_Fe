// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:intl/intl.dart';

class ShopServiceEntity {
  ShopServiceEntity({
    required this.serviceId,
    required this.shopId,
    required this.shopName,
    required this.profilePicture,
    required this.city,
    required this.district,
    required this.address,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
    required this.duration,
    required this.serviceSlots,
    required this.mediaFiles,
  });

  final int? serviceId;
  final int? shopId;
  final String? shopName;
  final String? profilePicture;
  final String? city;
  final String? district;
  final String? address;
  final String? name;
  final String? description;
  final double? price;
  final String? status;
  final int? duration;
  final dynamic serviceSlots;
  final List<dynamic> mediaFiles;
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


}
