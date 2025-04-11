// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:intl/intl.dart';

import 'package:tracio_fe/common/helper/schedule_model.dart';

import '../../../../data/shop/models/booking_detail_model.dart';

class BookingDetailEntity {
  BookingDetailEntity({
    this.bookingId,
    this.bookingDetailId,
    this.shopId,
    this.shopName,
    this.profilePicture,
    this.contactNumber,
    this.city,
    this.district,
    this.address,
    this.openTime,
    this.closeTime,
    this.isOverlap,
    this.serviceId,
    this.serviceName,
    this.bookedDate,
    this.estimatedEndDate,
    this.reason,
    this.duration,
    this.status,
    this.userNote,
    this.shopNote,
    this.price,
    this.serviceMediaFile,
    this.incidentalCharges,
    this.userDayFrees,
  });

  final int? bookingId;
  final int? bookingDetailId;
  final int? shopId;
  final String? shopName;
  final String? profilePicture;
  final String? contactNumber;
  final String? city;
  final String? district;
  final String? address;
  final String? openTime;
  final String? closeTime;
  final bool? isOverlap;
  final int? serviceId;
  final String? serviceName;
  final DateTime? bookedDate;
  final DateTime? estimatedEndDate;
  final String? reason;
  final int? duration;
  final String? status;
  final String? userNote;
  final String? shopNote;
  final double? price;
  final String? serviceMediaFile;
  final List<IncidentalCharge>? incidentalCharges;
  final List<ScheduleModel>? userDayFrees;

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
