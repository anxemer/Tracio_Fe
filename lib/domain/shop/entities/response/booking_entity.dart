// ignore_for_file: public_member_api_docs, sort_constructors_first

class BookingEntity {
  BookingEntity({
    required this.bookingId,
    required this.bookingDetailId,
    required this.serviceName,
    required this.serviceMediaFile,
    required this.shopName,
    required this.cyclistName,
    required this.cyclistAvatar,
    this.openTime,
    this.closeTime,
    required this.bookedDate,
    required this.duration,
    required this.estimatedEndDate,
    required this.status,
    required this.price,
  });

  final int? bookingId;
  final int? bookingDetailId;
  final String? serviceName;
  final String? serviceMediaFile;
  final String? shopName;
  final String? cyclistName;
  final String? cyclistAvatar;
  final String? openTime;
  final String? closeTime;
  final DateTime? bookedDate;
  final int? duration;
  final DateTime? estimatedEndDate;
  final String? status;
  final double? price;

  int? get openHour {
    if (openTime == null || !openTime!.contains(':')) return null;
    return int.tryParse(openTime!.split(':')[0]);
  }

  int? get closeHour {
    if (closeTime == null || !closeTime!.contains(':')) return null;
    return int.tryParse(closeTime!.split(':')[0]);
  }
}
