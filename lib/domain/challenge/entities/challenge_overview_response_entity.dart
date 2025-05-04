import 'package:tracio_fe/domain/challenge/entities/challenge_entity.dart';

class ChallengeOverviewResponseEntity {
  final List<ChallengeEntity> activeChallenges;
  final List<ChallengeEntity> suggestedChallenges;
  ChallengeOverviewResponseEntity({
    required this.activeChallenges,
    required this.suggestedChallenges,
  });
}
