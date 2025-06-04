import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class PostReviewReq {
  final int routeId;
  final List<int>? tagUserIds;
  final List<String>? tagUserNames;
  final String? content;
  final List<File>? file;

  const PostReviewReq({
    required this.routeId,
    this.tagUserIds,
    this.tagUserNames,
    this.content,
    this.file,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'RouteId': routeId,
      if (content != null) 'Content': content,
      if (tagUserIds != null) 'TagUserIds': tagUserIds,
      if (tagUserNames != null) 'TagUserNames': tagUserNames,
    };

    if (file != null && file!.isNotEmpty) {
      List<MultipartFile> files = []; // 👈 Đặt trong block này

      for (var file in file!) {
        if (await file.exists()) {
          final image =
              p.extension(file.path).toLowerCase().replaceFirst('.', '');
          files.add(await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: DioMediaType.parse('image/$image'),
          ));
        } else {
          print("⚠️ File không tồn tại: ${file.path}");
        }
      }

      if (files.isNotEmpty) {
        map['Files'] = files;
      }
    }

    return FormData.fromMap(map);
  }
}
