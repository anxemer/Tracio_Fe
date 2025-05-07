import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Tracio/core/configs/utils/validators/group_validator.dart';
import 'package:Tracio/data/groups/models/request/post_group_req.dart';
import 'package:Tracio/domain/groups/entities/group_req.dart';

part 'form_group_state.dart';

class FormGroupCubit extends Cubit<FormGroupState> with GroupValidator {
  FormGroupCubit()
      : super(FormGroupStateUpdate(
            groupRequest: GroupReq(
          groupName: '',
          description: '',
          groupThumbnail: null,
          isPublic: true,
          maxParticipants: 10,
          city: '',
          district: '',
        )));

  void validateStep(int step) async {
    final req = state.groupRequest;
    bool canProceed = false;

    switch (step) {
      case 0:
        canProceed = validateName(req.groupName) == null &&
            await validateImage(req.groupThumbnail) == null &&
            req.maxParticipants > 0;
        break;
      case 1:
        canProceed = true; // isPublic is bool, so always valid
        break;
      case 2:
        canProceed = validateCity(req.city) == null &&
            validateDistrict(req.district) == null;
        break;
    }

    emit((state as FormGroupStateUpdate).copyWith(
      canNext: step < 2 ? canProceed : false,
      canSubmit: step == 2 ? canProceed : false,
    ));
  }

  // Initialize the form with optional values
  void initForm(
      {String groupName = '',
      String description = '',
      File? groupThumbnail,
      bool isPublic = true,
      int maxParticipants = 10,
      String city = '',
      String district = ''}) {
    final newGroupReq = GroupReq(
      groupName: groupName,
      description: description,
      groupThumbnail: groupThumbnail,
      isPublic: isPublic,
      maxParticipants: maxParticipants,
      city: city,
      district: district,
    );
    emit(FormGroupStateUpdate(
      groupRequest: newGroupReq,
    ));
  }

  // Update group name
  void updateGroupName(String groupName) {
    final updatedGroupReq = state.groupRequest.copyWith(groupName: groupName);
    emit(FormGroupStateUpdate(
      groupRequest: updatedGroupReq,
    ));
  }

  void updatePrivacy(bool isPublic) {
    final updatedGroupReq = state.groupRequest.copyWith(isPublic: isPublic);
    emit(FormGroupStateUpdate(
      groupRequest: updatedGroupReq,
    ));
  }

  // Update group description
  void updateDescription(String description) {
    final updatedGroupReq =
        state.groupRequest.copyWith(description: description);
    emit(FormGroupStateUpdate(
      groupRequest: updatedGroupReq,
    ));
  }

  // Update group thumbnail
  void updateGroupThumbnail(File groupThumbnail) {
    final updatedGroupReq =
        state.groupRequest.copyWith(groupThumbnail: groupThumbnail);
    emit(FormGroupStateUpdate(
      groupRequest: updatedGroupReq,
    ));
  }

  // Toggle public/private
  void togglePublic(bool isPublic) {
    final updatedGroupReq = state.groupRequest.copyWith(isPublic: isPublic);
    emit(FormGroupStateUpdate(
      groupRequest: updatedGroupReq,
    ));
  }

  // Update max participants
  void updateMaxParticipants(int maxParticipants) {
    final updatedGroupReq =
        state.groupRequest.copyWith(maxParticipants: maxParticipants);
    emit(FormGroupStateUpdate(
      groupRequest: updatedGroupReq,
    ));
  }

  void updateDistrictCity(String city, String district) {
    final updatedGroupReq =
        state.groupRequest.copyWith(city: city, district: district);
    emit(FormGroupStateUpdate(
      groupRequest: updatedGroupReq,
    ));
  }

  PostGroupReq toPostGroupReq() {
    final req = state.groupRequest;
    return PostGroupReq(
      groupName: req.groupName,
      description: req.description,
      city: req.city,
      district: req.district,
      groupThumbnail: req.groupThumbnail!,
      isPublic: req.isPublic,
      maxParticipants: req.maxParticipants,
    );
  }
}
