// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GroupResponseModel {
  final String groupId;
  final String groupName;
  final String? description;
  final String groupThumbnail;
  final bool isPublic;
  final int maxParticipants;
  final String district;
  final String city;
  final DateTime createdAt;
  final DateTime updatedAt;
  GroupResponseModel({
    required this.groupId,
    required this.groupName,
    required this.description,
    required this.groupThumbnail,
    required this.isPublic,
    required this.maxParticipants,
    required this.district,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
  });

  GroupResponseModel copyWith({
    String? groupId,
    String? groupName,
    String? description,
    String? groupThumbnail,
    bool? isPublic,
    int? maxParticipants,
    String? district,
    String? city,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GroupResponseModel(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      groupThumbnail: groupThumbnail ?? this.groupThumbnail,
      isPublic: isPublic ?? this.isPublic,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      district: district ?? this.district,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupId': groupId,
      'groupName': groupName,
      'description': description,
      'groupThumbnail': groupThumbnail,
      'isPublic': isPublic,
      'maxParticipants': maxParticipants,
      'district': district,
      'city': city,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory GroupResponseModel.fromMap(Map<String, dynamic> map) {
    return GroupResponseModel(
      groupId: map['groupId'] as String,
      groupName: map['groupName'] as String,
      description: map['description'] as String,
      groupThumbnail: map['groupThumbnail'] as String,
      isPublic: map['isPublic'] as bool,
      maxParticipants: map['maxParticipants'] as int,
      district: map['district'] as String,
      city: map['city'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory GroupResponseModel.fromJson(String source) =>
      GroupResponseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GroupResponseModel(groupId: $groupId, groupName: $groupName, description: $description, groupThumbnail: $groupThumbnail, isPublic: $isPublic, maxParticipants: $maxParticipants, district: $district, city: $city, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant GroupResponseModel other) {
    if (identical(this, other)) return true;

    return other.groupId == groupId &&
        other.groupName == groupName &&
        other.description == description &&
        other.groupThumbnail == groupThumbnail &&
        other.isPublic == isPublic &&
        other.maxParticipants == maxParticipants &&
        other.district == district &&
        other.city == city &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return groupId.hashCode ^
        groupName.hashCode ^
        description.hashCode ^
        groupThumbnail.hashCode ^
        isPublic.hashCode ^
        maxParticipants.hashCode ^
        district.hashCode ^
        city.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
