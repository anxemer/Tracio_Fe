import 'dart:convert';

import 'package:tracio_fe/domain/blog/entites/reaction_response_entity.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
List<GetReactionBlogResponse> reactionBlogModelListFromRemoteJson(String str) =>
    List<GetReactionBlogResponse>.from(json
        .decode(str)['result']['reactions']
        .map((x) => GetReactionBlogResponse.fromJson(x)));

class GetReactionBlogResponse extends ReactionResponseEntity {
  GetReactionBlogResponse({
    super.cyclistId,
    super.cyclistName,
    super.cyclistAvatar,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cyclistId': cyclistId,
      'cyclistName': cyclistName,
      'cyclistAvatar': cyclistAvatar,
    };
  }

  factory GetReactionBlogResponse.fromMap(Map<String, dynamic> map) {
    return GetReactionBlogResponse(
      cyclistId: map['cyclistId'] != null ? map['cyclistId'] as int : null,
      cyclistName:
          map['cyclistName'] != null ? map['cyclistName'] as String : null,
      cyclistAvatar:
          map['cyclistAvatar'] != null ? map['cyclistAvatar'] as String : null,
      
    );
  }

  String toJson() => json.encode(toMap());

  factory GetReactionBlogResponse.fromJson(String source) =>
      GetReactionBlogResponse.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
