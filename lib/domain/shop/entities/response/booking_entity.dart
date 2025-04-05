// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:tracio_fe/common/helper/media_file.dart';

class BookingEntity {
  final int? bookingId;
  final String? serviceName;
  final DateTime? receivedAt;
  final List<MediaFile>? serviceMediaFile;
  final String? shopName;
  final String? profilePicture;
  final DateTime? bookedDate;
  final int? duration;
  final DateTime? estimatedEndDate;
  final String? status;
  final String? userNote;
  final String? shopNote;
  final double? price;
  BookingEntity({
    this.bookingId,
    this.serviceName,
    this.receivedAt,
    this.serviceMediaFile,
    this.shopName,
    this.profilePicture,
    this.bookedDate,
    this.duration,
    this.estimatedEndDate,
    this.status,
    this.userNote,
    this.shopNote,
    this.price,
  });

 
}
