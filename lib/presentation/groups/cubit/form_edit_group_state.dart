import 'package:flutter/material.dart';

@immutable
abstract class FormEditGroupState {
  final AutovalidateMode autovalidateMode;
  final String groupName;
  final String description;
  final String city;
  final String district;
  final String groupThumbnail;
  final int maxParticipants;
  final bool isPublic;

  const FormEditGroupState({
    this.autovalidateMode = AutovalidateMode.disabled,
    this.groupName = '',
    this.description = '',
    this.city = '',
    this.district = '',
    this.groupThumbnail = '',
    this.maxParticipants = 0,
    this.isPublic = true,
  });

  FormEditGroupState copyWith({
    AutovalidateMode? autovalidateMode,
    String? groupName,
    String? description,
    String? city,
    String? district,
    String? groupThumbnail,
    int? maxParticipants,
    bool? isPublic,
  });
}

class FormEditGroupUpdate extends FormEditGroupState {
  const FormEditGroupUpdate({
    super.autovalidateMode,
    super.groupName,
    super.description,
    super.city,
    super.district,
    super.groupThumbnail,
    super.maxParticipants,
    super.isPublic,
  });

  @override
  FormEditGroupUpdate copyWith({
    AutovalidateMode? autovalidateMode,
    String? groupName,
    String? description,
    String? city,
    String? district,
    String? groupThumbnail,
    int? maxParticipants,
    bool? isPublic,
  }) {
    return FormEditGroupUpdate(
      autovalidateMode: autovalidateMode ?? this.autovalidateMode,
      groupName: groupName ?? this.groupName,
      description: description ?? this.description,
      city: city ?? this.city,
      district: district ?? this.district,
      groupThumbnail: groupThumbnail ?? this.groupThumbnail,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}
