class ReactBlogReq {
  ReactBlogReq({
    required this.entityId,
    required this.entityType,
  });

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
        "entityId": entityId,
        "entityType": entityType,
      };
}
