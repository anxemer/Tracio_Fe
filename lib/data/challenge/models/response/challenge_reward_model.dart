import 'package:Tracio/domain/challenge/entities/challenge_reward.dart';

class ChallengeRewardModel extends ChallengeRewardEntity {
  ChallengeRewardModel(
      {required super.challengeRewardId,
      required super.challengeId,
      required super.rewardId,
      required super.name,
      required super.description,
      required super.imageUrl,
      required super.createdAt});

  factory ChallengeRewardModel.fromJson(Map<String, dynamic> json) {
    return ChallengeRewardModel(
      challengeRewardId: json["challengeRewardId"],
      challengeId: json["challengeId"],
      rewardId: json["rewardId"],
      name: json["name"],
      description: json["description"],
      imageUrl: json["imageUrl"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "challengeRewardId": challengeRewardId,
        "challengeId": challengeId,
        "rewardId": rewardId,
        "name": name,
        "description": description,
        "imageUrl": imageUrl,
        "createdAt": createdAt?.toIso8601String(),
      };
}
