import 'dart:io';

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

    // Kiểm tra null cho mediaFiles
    if (mediaFiles != null) {
      for (var file in mediaFiles!) {
        if (await file.exists()) {
          files.add(await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last));
        } else {
          print("⚠️ File không tồn tại: ${file.path}");
        }
      }
    } else {
      print("No media files provided");
    }

    return FormData.fromMap({
      'BlogId': blogId.toString(),
      'Content': content,
      'files': files,
    });
  }
}
