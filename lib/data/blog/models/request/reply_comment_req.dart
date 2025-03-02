// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:dio/dio.dart';

class ReplyCommentReq {
  final int commentId;
  final String content;
  final List<File>? files; // Đặt là nullable vì có thể không có file

  ReplyCommentReq({
    required this.commentId,
    required this.content,
    this.files,
  });

  // Phương thức để chuyển đổi thành FormData
  Future<FormData> toFormData() async {
    List<MultipartFile> mutibleFiles = [];

    // Kiểm tra null cho mediaFiles
    if (files != null) {
      for (var file in files!) {
        if (await file.exists()) {
          mutibleFiles.add(await MultipartFile.fromFile(file.path,
              filename: file.path.split('/').last));
        } else {
          print("⚠️ File không tồn tại: ${file.path}");
        }
      }
    } else {
      print("No media files provided");
    }

    return FormData.fromMap({
      'commentId': commentId.toString(),
      'Content': content,
      'files': files,
    });
  }
}
