// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class PostGroupReq {
  String groupName;
  String description;
  String city;
  String district;
  File groupThumbnail;
  bool isPublic;
  int maxParticipants;
  PostGroupReq({
    required this.groupName,
    required this.description,
    required this.city,
    required this.district,
    required this.groupThumbnail,
    required this.isPublic,
    required this.maxParticipants,
  });

  PostGroupReq copyWith({
    String? groupName,
    String? description,
    String? city,
    String? district,
    File? groupThumbnail,
    bool? isPublic,
    int? maxParticipants,
  }) {
    return PostGroupReq(
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      city: city ?? this.city,
      district: district ?? this.district,
      groupThumbnail: groupThumbnail ?? this.groupThumbnail,
      isPublic: isPublic ?? this.isPublic,
      maxParticipants: maxParticipants ?? this.maxParticipants,
    );
  }

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'groupName': groupName,
      'description': description,
      'city': city,
      'district': district,
      'groupThumbnail': await MultipartFile.fromFile(groupThumbnail.path,
          filename: groupThumbnail.path.split('/').last),
      'isPublic': isPublic,
      'maxParticipants': maxParticipants,
    });
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupName': groupName,
      'description': description,
      'city': city,
      'district': district,
      'groupThumbnail': groupThumbnail,
      'isPublic': isPublic,
      'maxParticipants': maxParticipants,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'PostGroupReq(groupName: $groupName, description: $description, city: $city, district: $district, groupThumbnail: $groupThumbnail, isPublic: $isPublic, maxParticipants: $maxParticipants)';
  }

  @override
  bool operator ==(covariant PostGroupReq other) {
    if (identical(this, other)) return true;

    return other.groupName == groupName &&
        other.description == description &&
        other.city == city &&
        other.district == district &&
        other.groupThumbnail == groupThumbnail &&
        other.isPublic == isPublic &&
        other.maxParticipants == maxParticipants;
  }

  @override
  int get hashCode {
    return groupName.hashCode ^
        description.hashCode ^
        city.hashCode ^
        district.hashCode ^
        groupThumbnail.hashCode ^
        isPublic.hashCode ^
        maxParticipants.hashCode;
  }
}
