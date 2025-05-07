import 'package:Tracio/data/challenge/models/response/challenge_reward_model.dart';
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';

class ChallengeModel extends ChallengeEntity {
  ChallengeModel(
      {required super.challengeId,
      required super.challengeThumbnail,
      required super.title,
      required super.description,
      required super.challengeType,
      required super.goalValue,
      required super.unit,
      required super.creatorId,
      required super.creatorName,
      required super.creatorAvatarUrl,
      required super.isSystem,
      required super.isPublic,
      required super.status,
      required super.progress,
      required super.totalParticipants,
      required super.challengeRank,
      required super.isCompleted,
      required super.startDate,
      required super.endDate,
      required super.createdAt,
      required super.challengeRewardMappings});
  factory ChallengeModel.fromJson(Map<String, dynamic> json) {
    return ChallengeModel(
      challengeId: json["challengeId"] as int?,
      challengeThumbnail: json["challengeThumbnail"] as String? ?? '',
      title: json["title"] as String? ?? '',
      description: json["description"] as String? ?? '',
      challengeType: json["challengeType"] as String? ?? '',
      goalValue:
          json["goalValue"] is num ? (json["goalValue"] as num).toInt() : 0,
      unit: json["unit"] as String? ?? '',
      creatorId: json["creatorId"] as int?,
      creatorName: json["creatorName"] as String? ?? '',
      creatorAvatarUrl: json["creatorAvatarUrl"] as String? ?? '',
      isSystem: json["isSystem"] as bool? ?? false,
      isPublic: json["isPublic"] as bool? ?? false,
      status: json["status"] as String? ?? '',
      progress: (json["progress"] is num)
          ? ((json["progress"] as num).toDouble() / 100).clamp(0.0, 1.0)
          : 0.0,
      challengeRank: json["challengeRank"] as int? ?? 0,
      isCompleted: json["isCompleted"] as bool? ?? false,
      startDate: DateTime.tryParse(json["startDate"]?.toString() ?? ""),
      endDate: DateTime.tryParse(json["endDate"]?.toString() ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"]?.toString() ?? ""),
      challengeRewardMappings: (json['challengeRewardMappings'] as List?)
              ?.map((x) =>
                  ChallengeRewardModel.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      totalParticipants: json["totalParticipants"] as int? ?? 0,
    );
  }
}
