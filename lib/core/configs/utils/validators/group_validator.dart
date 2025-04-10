import 'dart:io';

mixin GroupValidator {
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    return null;
  }

  String? validateDistrict(String? value) {
    if (value == null || value.isEmpty) {
      return 'District is required';
    }
    return null;
  }

  Future<String?> validateImage(File? value) async {
    if (value == null || !(await value.exists())) {
      return 'Image is required';
    }
    return null;
  }

  String? validateTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Activity title is required';
    }
    return null;
  }

  String? validateMeetingPoint(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Meeting point is required';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    return null;
  }

  String? validateDateTime(DateTime? value) {
    if (value == null) return 'Start date & time is required';

    final now = DateTime.now();
    final max = now.add(const Duration(days: 14));
    if (value.isBefore(now)) return 'Start time must be in the future';
    if (value.isAfter(max)) return 'Start time must be within 2 weeks';
    return null;
  }
}
