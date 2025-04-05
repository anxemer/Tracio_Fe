class Group {
  final int groupId;
  final String groupName;
  final String? description;
  final String groupThumbnail;
  final bool isPublic;
  final int maxParticipants;
  final String district;
  final String city;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int participantCount;
  final Creator creator;
  Group({
    required this.groupId,
    required this.groupName,
    this.description,
    required this.groupThumbnail,
    required this.isPublic,
    required this.maxParticipants,
    required this.district,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
    required this.participantCount,
    required this.creator,
  });

  String get formattedDate {
    return "${createdAt!.day}-${createdAt!.month}-${createdAt!.year}";
  }

  int get remainingSpots => maxParticipants - 50;
}


class Creator {
  final int userId;
  final String username;
  final String profilePicture;
  Creator({
    required this.userId,
    required this.username,
    required this.profilePicture,
  });
}