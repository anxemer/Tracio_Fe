


class BookingEntity {
 BookingEntity({
        required this.bookingId,
        required this.bookingDetailId,
        required this.serviceName,
        required this.serviceMediaFile,
        required this.shopName,
        required this.cyclistName,
        required this.cyclistAvatar,
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
    final DateTime? bookedDate;
    final int? duration;
    final DateTime? estimatedEndDate;
    final String? status;
    final double? price;
}
