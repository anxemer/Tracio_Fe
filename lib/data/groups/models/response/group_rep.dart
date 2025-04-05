import 'dart:convert';

import 'package:tracio_fe/domain/groups/entities/group.dart';

class GroupResponseModel extends Group {
  GroupResponseModel(
      {required super.groupId,
      required super.groupName,
      super.description,
      required super.groupThumbnail,
      required super.isPublic,
      required super.maxParticipants,
      required super.district,
      required super.city,
      required super.createdAt,
      required super.updatedAt,
      required super.participantCount,
      required super.creator});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupId': groupId.toString(),
      'groupName': groupName,
      'description': description,
      'groupThumbnail': groupThumbnail,
      'isPublic': isPublic,
      'maxParticipants': maxParticipants,
      'district': district,
      'city': city,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }

  factory GroupResponseModel.fromMap(Map<String, dynamic> map) {
    return GroupResponseModel(
      groupId: map['groupId'] as int,
      groupName: map['groupName'] as String,
      description: map['description'] ?? '',
      groupThumbnail: map['groupThumbnail'] as String,
      isPublic: map['isPublic'] as bool,
      maxParticipants: map['maxParticipants'] as int,
      district: map['district'] ?? "",
      city: map['city'] ?? "",
      createdAt: DateTime.tryParse(map["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(map["updatedAt"] ?? ""),
      participantCount: map['participantCount'] as int,
      creator: Creator(
        userId: map['creator']['userId'] as int,
        username: map['creator']['userName'] as String,
        profilePicture: map['creator']['profilePicture'] as String,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupResponseModel.fromJson(String source) =>
      GroupResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
