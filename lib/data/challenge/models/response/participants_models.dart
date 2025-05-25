import 'package:Tracio/domain/challenge/entities/participants_entity.dart';

class ParticipantsModels extends ParticipantsEntity {
  ParticipantsModels({
    required super.challengeId,
    required super.cyclistId,
    required super.cyclistName,
    required super.cyclistAvatarUrl,
    required super.progress,
    required super.pace,
    required super.challengeRank,
    required super.isCompleted,
    required super.joinedAt,
    required super.completedAt,
    required super.isRewardClaimed,
    required super.isCurrentUser,
  });

  factory ParticipantsModels.fromJson(Map<String, dynamic> json) {
    return ParticipantsModels(
      challengeId: json["challengeId"],
      cyclistId: json["cyclistId"],
      cyclistName: json["cyclistName"],
      cyclistAvatarUrl: json["cyclistAvatarUrl"],
      progress: (json["progress"] is num)
          ? ((json["progress"] as num).toDouble() / 100).clamp(0.0, 1.0)
          : 0.0,
      pace: json['pace'] != null ? (json['pace'] as num).toDouble() : null,
      challengeRank: json["challengeRank"],
      isCompleted: json["isCompleted"],
      joinedAt:
          json["joinedAt"] != null ? DateTime.tryParse(json["joinedAt"]) : null,
      completedAt: json["completedAt"] != null
          ? DateTime.tryParse(json["completedAt"])
          : null,
      isRewardClaimed: json["isRewardClaimed"],
      isCurrentUser: json["isCurrentUser"],
    );
  }

  Map<String, dynamic> toJson() => {
        "challengeId": challengeId,
        "cyclistId": cyclistId,
        "cyclistName": cyclistName,
        "cyclistAvatarUrl": cyclistAvatarUrl,
        "progress": progress,
        "pace": pace,
        "challengeRank": challengeRank,
        "isCompleted": isCompleted,
        "joinedAt": joinedAt?.toIso8601String(),
        "completedAt": completedAt,
        "isRewardClaimed": isRewardClaimed,
      };
}
