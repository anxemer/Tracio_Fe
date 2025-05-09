import 'dart:io';

class GroupReq {
  final String groupName;
  final String description;
  final File? groupThumbnail;
  final bool isPublic;
  final int maxParticipants;
  final String district;
  final String city;
  GroupReq(
      {required this.groupName,
      required this.description,
      required this.groupThumbnail,
      required this.isPublic,
      required this.maxParticipants,
      required this.city,
      required this.district});

  GroupReq copyWith(
      {String? groupName,
      String? description,
      File? groupThumbnail,
      bool? isPublic,
      int? maxParticipants,
      String? city,
      String? district}) {
    return GroupReq(
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      groupThumbnail: groupThumbnail ?? this.groupThumbnail,
      isPublic: isPublic ?? this.isPublic,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      city: city ?? this.city,
      district: district ?? this.district,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupName': groupName,
      'description': description,
      'groupThumbnail': groupThumbnail,
      'isPublic': isPublic,
      'maxParticipants': maxParticipants,
      "district": district,
      "city": city
    };
  }
}
