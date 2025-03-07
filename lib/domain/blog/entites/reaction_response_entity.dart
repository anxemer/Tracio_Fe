class ReactionResponseEntity {
  final int? reactionId;
  final int? cyclistId;
  final String? cyclistName;
  final String? cyclistAvatar;
  final DateTime? createdAt;
  ReactionResponseEntity({
    this.reactionId,
    this.cyclistId,
    this.cyclistName,
    this.cyclistAvatar,
    this.createdAt,
  });
}
