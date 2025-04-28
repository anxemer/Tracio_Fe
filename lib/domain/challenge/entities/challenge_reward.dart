class ChallengeRewardEntity {
   ChallengeRewardEntity({
        required this.challengeRewardId,
        required this.challengeId,
        required this.rewardId,
        required this.name,
        required this.description,
        required this.imageUrl,
        required this.createdAt,
    });

    final int? challengeRewardId;
    final int? challengeId;
    final int? rewardId;
    final String? name;
    final String? description;
    final String? imageUrl;
    final DateTime? createdAt;



}