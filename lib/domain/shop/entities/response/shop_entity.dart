// ignore_for_file: public_member_api_docs, sort_constructors_first
class ShopEntity {
  ShopEntity({
    required this.shopId,
    required this.shopName,
    required this.profilePicture,
    required this.city,
    required this.district,
    this.distance,
    required this.address,
  });

  final int? shopId;
  final String? shopName;
  final String? profilePicture;
  final String? city;
  final String? district;
  final double? distance;
  final String? address;

  String get formattedDistance {
    if (distance == null) return "0km 0m";
    final km = distance!.floor();
    final m = ((distance! - km) * 1000).round();
    return "${km}km ${m}m";
  }
}
