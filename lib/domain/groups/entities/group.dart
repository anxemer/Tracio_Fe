import 'package:tracio_fe/core/constants/membership_enum.dart';

class Group {
  final int groupId;
  final int creatorId;
  final String creatorName;
  final String creatorAvatarUrl;
  final String groupName;
  final String? description;
  final String groupThumbnail;
  final bool isPublic;
  final int maxParticipants;
  final int totalGroupRoutes;
  final String district;
  final String city;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int participantCount;
  final MembershipEnum membership;
  Group(
      {required this.groupId,
      required this.creatorId,
      required this.groupName,
      required this.creatorName,
      required this.creatorAvatarUrl,
      this.description,
      required this.groupThumbnail,
      required this.isPublic,
      required this.maxParticipants,
      required this.totalGroupRoutes,
      required this.district,
      required this.city,
      required this.createdAt,
      required this.updatedAt,
      required this.participantCount,
      required this.membership});

  String get formattedDate {
    return "${createdAt!.day}-${createdAt!.month}-${createdAt!.year}";
  }

  int get remainingSpots => maxParticipants - participantCount;

  Group copyWith({
    int? participantCount,
    MembershipEnum? membership,
  }) {
    return Group(
      participantCount: participantCount ?? this.participantCount,
      membership: membership ?? this.membership,
      groupId: groupId,
      creatorId: creatorId,
      creatorName: creatorName,
      creatorAvatarUrl: creatorAvatarUrl,
      groupName: groupName,
      description: description,
      groupThumbnail: groupThumbnail,
      isPublic: isPublic,
      maxParticipants: maxParticipants,
      totalGroupRoutes: totalGroupRoutes,
      district: district,
      city: city,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
