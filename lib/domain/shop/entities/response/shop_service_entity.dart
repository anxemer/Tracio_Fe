// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:intl/intl.dart';

import 'package:Tracio/common/helper/media_file.dart';

class ShopServiceEntity {
  final int? serviceId;
  final int? shopId;
  final String? shopName;
  final String? openTime;
  final String? closeTime;
  final String? categoryName;
  final String? profilePicture;
  final String? city;
  final String? district;
  final String? serviceName;
  final String? description;
  final double? price;
  final String? status;
  final int? totalBookings;
  final double? avgRating;
  final int? duration;
  final int? totalReviews;
  final double? distance;
  final List<MediaFile>? mediaFiles;
  ShopServiceEntity({
    this.serviceId,
    this.shopId,
    this.shopName,
    this.openTime,
    this.closeTime,
    this.categoryName,
    this.profilePicture,
    this.city,
    this.district,
    this.serviceName,
    this.description,
    this.price,
    this.status,
    this.totalBookings,
    this.avgRating,
    this.duration,
    this.totalReviews,
    this.distance,
    this.mediaFiles,
  });
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

  String? get mediaUrl {
    if (mediaFiles != null && mediaFiles!.isNotEmpty) {
      return mediaFiles!.first.mediaUrl;
    }
    return null;
  }

  String get formattedPrice {
    double priceAsInt = price!.toDouble();

    final formatter = NumberFormat('#,###', 'vi_VN');
    return formatter.format(priceAsInt);
  }
}
