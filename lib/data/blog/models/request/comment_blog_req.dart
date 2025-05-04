import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:dio/dio.dart';

class CommentBlogReq {
  CommentBlogReq({
    required this.blogId,
    required this.content,
    this.mediaFiles,
  });

  final int blogId;
  final String content;
  final List<File>? mediaFiles;

  Future<FormData> toFormData() async {
    List<MultipartFile> files = [];
    final Map<String, dynamic> data = {
      'BlogId': blogId.toString(),
      'Content': content,
      'files': files,
    };
    if (mediaFiles != null && mediaFiles!.isNotEmpty) {
      // List<MultipartFile> files = [];
      for (var file in mediaFiles!) {
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
        data['ProfilePicture'] = files;
      }
    }

    return FormData.fromMap(data);
  }
}
