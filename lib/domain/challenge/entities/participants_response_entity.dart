// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:Tracio/domain/challenge/entities/participants_entity.dart';

class ParticipantsResponseEntity {
  final ParticipantsEntity currentUser;
  final List<ParticipantsEntity> listParticipants;
  ParticipantsResponseEntity({
    required this.currentUser,
    required this.listParticipants,
  });

  

}
