import 'dart:io';

import 'package:dio/dio.dart';

class CreateBlogReq {
  final int categoryId;
  final String content;
  final int privacySetting;
  final int status;
  final List<File> mediaFiles;

  CreateBlogReq({
    required this.categoryId,
    required this.content,
    required this.privacySetting,
    required this.status,
    required this.mediaFiles,
  });

  /// ✅ Chuyển dữ liệu thành `FormData`
  Future<FormData> toFormData() async {
    List<MultipartFile> files = [];

    for (var file in mediaFiles) {
      if (await file.exists()) {
        files.add(await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last));
      } else {
        print("⚠️ File không tồn tại: ${file.path}");
      }
    }

    return FormData.fromMap({
      // BlogCreateDto phải đúng với API
      'CategoryId': categoryId.toString(), // Chuyển số thành chuỗi
      'Content': content,
      'PrivacySetting': privacySetting.toString(),
      'Status': status.toString(),
      'mediaFiles': files, // ✅ Đúng với API
    });
  }
}
