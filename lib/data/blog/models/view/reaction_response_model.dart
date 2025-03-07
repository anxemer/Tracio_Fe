import 'dart:convert';

import 'package:tracio_fe/domain/blog/entites/reaction_response_entity.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReactionResponseModel {
  final int? reactionId;
  final int? cyclistId;
  final String? cyclistName;
  final String? cyclistAvatar;
  final DateTime? createdAt;
  ReactionResponseModel({
    this.reactionId,
    this.cyclistId,
    this.cyclistName,
    this.cyclistAvatar,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reactionId': reactionId,
      'cyclistId': cyclistId,
      'cyclistName': cyclistName,
      'cyclistAvatar': cyclistAvatar,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory ReactionResponseModel.fromMap(Map<String, dynamic> map) {
    return ReactionResponseModel(
      reactionId: map['reactionId'] != null ? map['reactionId'] as int : null,
      cyclistId: map['cyclistId'] != null ? map['cyclistId'] as int : null,
      cyclistName:
          map['cyclistName'] != null ? map['cyclistName'] as String : null,
      cyclistAvatar:
          map['cyclistAvatar'] != null ? map['cyclistAvatar'] as String : null,
      createdAt: DateTime.tryParse(map["createdAt"] ?? ""),
    );
  }

  String toJson() => json.encode(toMap());

  factory ReactionResponseModel.fromJson(String source) =>
      ReactionResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

extension ReactionXModel on ReactionResponseModel {
  ReactionResponseEntity toentity() {
    return ReactionResponseEntity(
        createdAt: createdAt,
        cyclistAvatar: cyclistAvatar,
        cyclistId: cyclistId,
        cyclistName: cyclistAvatar,
        reactionId: reactionId);
  }
}
