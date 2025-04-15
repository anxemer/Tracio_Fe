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
}
