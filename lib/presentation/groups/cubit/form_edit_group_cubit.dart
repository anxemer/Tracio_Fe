import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracio_fe/presentation/groups/cubit/form_edit_group_state.dart';

class FormEditGroupCubit extends Cubit<FormEditGroupState> {
  FormEditGroupCubit() : super(const FormEditGroupUpdate());

  // Initialize the form with optional values
  void initForm({
    String groupName = '',
    String description = '',
    String city = '',
    String district = '',
    String groupThumbnail = '',
    int maxParticipants = 0,
    bool isPublic = true,
  }) {
    emit(state.copyWith(
      groupName: groupName,
      description: description,
      city: city,
      district: district,
      groupThumbnail: groupThumbnail,
      maxParticipants: maxParticipants,
      isPublic: isPublic,
    ));
  }

  // Update group name
  void updateGroupName(String groupName) {
    emit(state.copyWith(groupName: groupName));
  }

  // Update description
  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  // Update city
  void updateCity(String city) {
    emit(state.copyWith(city: city));
  }

  // Update district
  void updateDistrict(String district) {
    emit(state.copyWith(district: district));
  }

  // Update group thumbnail
  void updateGroupThumbnail(String groupThumbnail) {
    emit(state.copyWith(groupThumbnail: groupThumbnail));
  }

  // Update max participants
  void updateMaxParticipants(int maxParticipants) {
    emit(state.copyWith(maxParticipants: maxParticipants));
  }

  // Update isPublic flag
  void togglePublic(bool isPublic) {
    emit(state.copyWith(isPublic: isPublic));
  }

  // Update AutovalidateMode
  void updateAutovalidateMode(AutovalidateMode autovalidateMode) {
    emit(state.copyWith(autovalidateMode: autovalidateMode));
  }

  // Reset the form to initial state
  void reset() {
    emit(const FormEditGroupUpdate());
  }
}
