class UpdateRouteReq {
  int routeId;
  String routeName;
  String? description;
  String? routeThumbnail;
  bool isPublic;
  String mood;
  UpdateRouteReq({
    required this.routeId,
    required this.routeName,
    required this.description,
    required this.routeThumbnail,
    required this.isPublic,
    required this.mood,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'routeName': routeName,
      'description': description,
      'routeThumbnail': routeThumbnail,
      'isPublic': isPublic,
      'mood': mood.toLowerCase(),
    };
  }
}
