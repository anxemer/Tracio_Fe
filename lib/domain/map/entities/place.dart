class PlaceEntity {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;

  PlaceEntity({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });
}

class PlaceDetailEntity {
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  PlaceDetailEntity({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}
