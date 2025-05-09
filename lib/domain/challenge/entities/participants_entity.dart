// ignore_for_file: public_member_api_docs, sort_constructors_first
class ParticipantsEntity {
  ParticipantsEntity({
    required this.challengeId,
    required this.cyclistId,
    required this.cyclistName,
    required this.cyclistAvatarUrl,
    required this.progress,
    required this.pace,
    required this.challengeRank,
    required this.isCompleted,
    required this.joinedAt,
    required this.completedAt,
    required this.isRewardClaimed,
    this.isCurrentUser,
  });

  final int? challengeId;
  final int? cyclistId;
  final String? cyclistName;
  final String? cyclistAvatarUrl;
  final double? progress;
  final double? pace;
  final int? challengeRank;
  final bool? isCompleted;
  final DateTime? joinedAt;
  final DateTime? completedAt;
  final bool? isRewardClaimed;
  final bool? isCurrentUser;

 
}
