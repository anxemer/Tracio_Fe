import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';

class CreateBlogReq {
  final int categoryId;
  final String content;
  final bool isPublic;
  final int status;
  final List<File> mediaFiles;

  CreateBlogReq({
    required this.categoryId,
    required this.content,
    required this.isPublic,
    required this.status,
    required this.mediaFiles,
  });

  /// ✅ Chuyển dữ liệu thành `FormData`
  Future<FormData> toFormData() async {
    List<MultipartFile> files = [];

    for (var file in mediaFiles) {
      if (await file.exists()) {
        final image =
            p.extension(file.path).toLowerCase().replaceFirst('.', '');
        files.add(await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last,
            contentType: DioMediaType.parse('image/$image')));
      } else {
        print("⚠️ File không tồn tại: ${file.path}");
      }
    }

    return FormData.fromMap({
      // BlogCreateDto phải đúng với API
      'CategoryId': categoryId.toString(), // Chuyển số thành chuỗi
      'Content': content,
      'IsPublic': isPublic.toString(),
      'Status': status.toString(),
      'mediaFiles': files, // ✅ Đúng với API
    });
  }
}
