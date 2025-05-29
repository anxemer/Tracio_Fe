import 'package:Tracio/data/challenge/models/response/challenge_model.dart';
import 'package:Tracio/domain/challenge/entities/challenge_overview_response_entity.dart';

class ChallengeOverviewResponseModel extends ChallengeOverviewResponseEntity {
  ChallengeOverviewResponseModel(
      {required super.activeChallenges,
      required super.suggestedChallenges,
      required super.previousChallenges,
      required super.myChallenges});

  factory ChallengeOverviewResponseModel.fromMap(Map<String, dynamic> map) {
    return ChallengeOverviewResponseModel(
        activeChallenges: map['activeChallenges']['items'] != null
            ? List<ChallengeModel>.from(map['activeChallenges']['items']
                .map((x) => ChallengeModel.fromJson(x as Map<String, dynamic>)))
            : [],
        suggestedChallenges: map['suggestedChallenges']['items'] != null
            ? List<ChallengeModel>.from(map['suggestedChallenges']['items']
                .map((x) => ChallengeModel.fromJson(x as Map<String, dynamic>)))
            : [],
        previousChallenges: map['previousChallenges']['items'] != null
            ? List<ChallengeModel>.from(map['previousChallenges']['items']
                .map((x) => ChallengeModel.fromJson(x as Map<String, dynamic>)))
            : [],
        myChallenges: map['myChallenges']['items'] != null
            ? List<ChallengeModel>.from(
                map['myChallenges']['items'].map((x) => ChallengeModel.fromJson(x as Map<String, dynamic>)))
            : []);
  }
}
