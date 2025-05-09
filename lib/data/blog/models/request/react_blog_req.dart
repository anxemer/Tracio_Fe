class ReactBlogReq {
  ReactBlogReq({
    required this.entityId,
    required this.entityType,
  });

  final int? entityId;
  final String? entityType;

 
  Map<String, dynamic> toJson() => {
        "entityId": entityId,
        "entityType": entityType,
      };
}
