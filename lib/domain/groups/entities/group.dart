import 'package:tracio_fe/data/groups/models/response/group_rep.dart';

class Group extends GroupResponseModel {
  Group({
    required super.groupId,
    required super.groupName,
    super.description,
    required super.groupThumbnail,
    required super.isPublic,
    required super.maxParticipants,
    required super.district,
    required super.city,
    required super.createdAt,
    required super.updatedAt,
  });

  // Example of a UI-specific method
  String get formattedDate {
    return "${createdAt.day}-${createdAt.month}-${createdAt.year}"; // Example format
  }

  int get remainingSpots => maxParticipants - 50;
}
