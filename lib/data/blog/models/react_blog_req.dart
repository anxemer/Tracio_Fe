class ReactBlogReq {
  ReactBlogReq({
    required this.cyclistId,
    required this.cyclistName,
    required this.entityId,
    required this.entityType,
  });

  final int? cyclistId;
  final String? cyclistName;
  final int? entityId;
  final String? entityType;

  // factory ReactBlogReq.fromJson(Map<String, dynamic> json) {
  //   return ReactBlogReq(
  //     cyclistId: json["cyclistId"],
  //     cyclistName: json["cyclistName"],
  //     entityId: json["entityId"],
  //     entityType: json["entityType"],
  //   );
  // }

  Map<String, dynamic> toJson() => {
        "cyclistId": cyclistId,
        "cyclistName": cyclistName,
        "entityId": entityId,
        "entityType": entityType,
      };
}
