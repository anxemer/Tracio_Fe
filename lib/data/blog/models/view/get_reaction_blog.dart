import 'dart:convert';

import 'package:tracio_fe/domain/blog/entites/reaction_response_entity.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
List<GetReactionBlogResponse> reactionBlogModelListFromRemoteJson(String str) =>
    List<GetReactionBlogResponse>.from(json
        .decode(str)['result']['reactions']
        .map((x) => GetReactionBlogResponse.fromJson(x)));

class GetReactionBlogResponse extends ReactionResponseEntity {
  GetReactionBlogResponse({
    super.reactionId,
    super.cyclistId,
    super.cyclistName,
    super.cyclistAvatar,
    super.createdAt,
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

  factory GetReactionBlogResponse.fromMap(Map<String, dynamic> map) {
    return GetReactionBlogResponse(
      reactionId: map['reactionId'] != null ? map['reactionId'] as int : null,
      cyclistId: map['cyclistId'] != null ? map['cyclistId'] as int : null,
      cyclistName:
          map['cyclistName'] != null ? map['cyclistName'] as String : null,
      cyclistAvatar:
          map['cyclistAvatar'] != null ? map['cyclistAvatar'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetReactionBlogResponse.fromJson(String source) =>
      GetReactionBlogResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
