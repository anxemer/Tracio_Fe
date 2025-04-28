// ignore_for_file: public_member_api_docs, sort_constructors_first
class ShopProfileEntity {
  ShopProfileEntity({
    required this.shopId,
    required this.ownerId,
    required this.taxCode,
    required this.shopName,
    required this.profilePicture,
    required this.coordinate,
    required this.contactNumber,
    required this.openTime,
    required this.closedTime,
    required this.isActive,
    required this.totalBooking,
    this.totalService,
    this.totalPendingBooking,
    required this.city,
    required this.district,
    required this.address,
  });

  final int? shopId;
  final int? ownerId;
  final String? taxCode;
  final String? shopName;
  final String? profilePicture;
  final CoordinateEntity? coordinate;
  final String? contactNumber;
  final String? openTime;
  final String? closedTime;
  final bool? isActive;
  final int? totalBooking;
  final int? totalService;
  final int? totalPendingBooking;
  final String? city;
  final String? district;
  final String? address;

  ShopProfileEntity copyWith({
    int? shopId,
    int? ownerId,
    String? taxCode,
    String? shopName,
    String? profilePicture,
    CoordinateEntity? coordinate,
    String? contactNumber,
    String? openTime,
    String? closedTime,
    bool? isActive,
    int? totalBooking,
    int? totalPendingBooking,
    String? city,
    String? district,
    String? address,
  }) {
    return ShopProfileEntity(
      shopId: shopId ?? this.shopId,
      ownerId: ownerId ?? this.ownerId,
      taxCode: taxCode ?? this.taxCode,
      shopName: shopName ?? this.shopName,
      profilePicture: profilePicture ?? this.profilePicture,
      coordinate: coordinate ?? this.coordinate,
      contactNumber: contactNumber ?? this.contactNumber,
      openTime: openTime ?? this.openTime,
      closedTime: closedTime ?? this.closedTime,
      isActive: isActive ?? this.isActive,
      totalBooking: totalBooking ?? this.totalBooking,
      totalPendingBooking: totalPendingBooking ?? this.totalPendingBooking,
      city: city ?? this.city,
      district: district ?? this.district,
      address: address ?? this.address,
    );
  }
}

class CoordinateEntity {
  CoordinateEntity({
    required this.longitude,
    required this.latitude,
  });

  final double? longitude;
  final double? latitude;
}
