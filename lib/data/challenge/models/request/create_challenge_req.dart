class CreateChallengeReq {
  CreateChallengeReq({
    required this.title,
    required this.description,
    required this.challengeType,
    required this.unit,
    required this.goalValue,
    required this.startDate,
    required this.endDate,
    this.rewardId,
  });

  final String? title;
  final String? description;
  final String? challengeType;
  final String? unit;
  final int? goalValue;
  final String? startDate;
  final String? endDate;
  final int? rewardId;

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "challengeType": challengeType,
        "unit": unit,
        "goalValue": goalValue,
        "startDate": startDate,
        "endDate": endDate,
        "rewardId": rewardId,
      };
}
