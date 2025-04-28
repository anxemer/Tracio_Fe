import 'package:tracio_fe/data/challenge/models/response/participants_models.dart';
import 'package:tracio_fe/domain/challenge/entities/participants_response_entity.dart';

class ParticipantsResponseModel extends ParticipantsResponseEntity {
  ParticipantsResponseModel(
      {required super.currentUser, required super.listParticipants});

  factory ParticipantsResponseModel.fromMap(Map<String, dynamic> map) {
    return ParticipantsResponseModel(
        currentUser: ParticipantsModels.fromJson(
            map['currentUser'] as Map<String, dynamic>),
        listParticipants: map['items'] != null
            ? List<ParticipantsModels>.from(map['items'].map(
                (x) => ParticipantsModels.fromJson(x as Map<String, dynamic>)))
            : []
        // List<ParticipantsModels>.from(
        //   (map['items'] as List<ParticipantsModels>).map<ParticipantsModels>(
        //     (x) => ParticipantsModels.fromJson(x as Map<String, dynamic>),
        //   ),
        // ),
        );
  }
}
