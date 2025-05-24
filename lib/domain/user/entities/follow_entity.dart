class FollowEntity {
  FollowEntity({
    required this.followerId,
    required this.followerName,
    required this.followerAvatarUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? followerId;
  final String? followerName;
  final String? followerAvatarUrl;
  final String? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}
