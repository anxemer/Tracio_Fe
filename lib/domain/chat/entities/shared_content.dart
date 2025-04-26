class SharedContentEntity {
  final String type;
  final int entityId;
  final int? creatorId;
  final String? creatorName;
  final String? creatorAvatar;
  final String summary;
  final String thumbnail;
  SharedContentEntity({
    required this.type,
    required this.entityId,
    required this.creatorId,
    required this.creatorName,
    required this.creatorAvatar,
    required this.summary,
    required this.thumbnail,
  });
}
