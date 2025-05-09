import 'package:Tracio/core/constants/membership_enum.dart';
import 'package:Tracio/domain/groups/entities/group.dart';

class GroupResponseModel extends Group {
  GroupResponseModel(
      {required super.groupId,
      required super.creatorId,
      required super.creatorName,
      required super.creatorAvatarUrl,
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
      required super.membership,
      required super.totalGroupRoutes});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupId': groupId.toString(),
      'creatorId': creatorId.toString(),
      'creatorName': creatorName,
      'creatorAvatarUrl': creatorAvatarUrl,
      'groupName': groupName,
      'description': description,
      'groupThumbnail': groupThumbnail,
      'isPublic': isPublic,
      'maxParticipants': maxParticipants,
      'totalGroupRoutes': totalGroupRoutes,
      'district': district,
      'city': city,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "membership": membership.toString()
    };
  }

  factory GroupResponseModel.fromMap(Map<String, dynamic> map) {
    return GroupResponseModel(
        groupId: map['groupId'] as int,
        creatorId: map['creatorId'] as int,
        creatorName: map['creatorName'] as String,
        creatorAvatarUrl: map['creatorAvatarUrl'] as String,
        groupName: map['groupName'] as String,
        description: map['description'] ?? '',
        groupThumbnail: map['groupThumbnail'] as String,
        isPublic: map['isPublic'] as bool,
        maxParticipants: map['maxParticipants'] as int,
        totalGroupRoutes: map['totalGroupRoutes'] as int,
        district: map['district'] ?? "",
        city: map['city'] ?? "",
        createdAt: DateTime.tryParse(map["createdAt"] ?? ""),
        updatedAt: map["updatedAt"] != null
            ? DateTime.tryParse(map["updatedAt"])
            : null,
        participantCount: map['totalParticipants'] as int,
        membership: MembershipEnum.values.firstWhere(
          (e) => e.name.toLowerCase() == map['membership'].toLowerCase(),
          orElse: () => MembershipEnum.none,
        ));
  }
}
