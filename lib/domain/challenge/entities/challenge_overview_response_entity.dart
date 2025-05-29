// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:Tracio/domain/challenge/entities/challenge_entity.dart';

class ChallengeOverviewResponseEntity {
  final List<ChallengeEntity> activeChallenges;
  final List<ChallengeEntity> suggestedChallenges;
  final List<ChallengeEntity> previousChallenges;
  final List<ChallengeEntity> myChallenges;
  ChallengeOverviewResponseEntity({
    required this.activeChallenges,
    required this.suggestedChallenges,
    required this.previousChallenges,
    required this.myChallenges,
  });
}
