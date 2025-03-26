class ShopEntity {
  ShopEntity({
    required this.shopId,
    required this.shopName,
    required this.profilePicture,
    required this.city,
    required this.district,
    required this.address,
  });

  final int? shopId;
  final String? shopName;
  final String? profilePicture;
  final String? city;
  final String? district;
  final String? address;
}
