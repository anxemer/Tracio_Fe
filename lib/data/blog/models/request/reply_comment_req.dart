import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:dio/dio.dart';

class ReplyCommentReq {
  final int? replyId;
  final int? commentId;
  final String content;
  final List<File>? files; // Đặt là nullable vì có thể không có file

  ReplyCommentReq({
    this.replyId,
    required this.commentId,
    required this.content,
    this.files,
  });

  // Phương thức để chuyển đổi thành FormData
  Future<FormData> toFormData() async {
    List<MultipartFile> mutibleFiles = [];
    Map<String, dynamic> formMap = {
      'CommentId': commentId.toString(),
      'Content': content,
      'files': mutibleFiles
    };
    if (files != null && files!.isNotEmpty) {
      // List<MultipartFile> files = [];
      for (var file in files!) {
        if (await file.exists()) {
          final image =
              p.extension(file.path).toLowerCase().replaceFirst('.', '');
          mutibleFiles.add(await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
            contentType: DioMediaType.parse('image/$image'),
          ));
        } else {
          print("⚠️ File không tồn tại: ${file.path}");
        }
      }

      if (mutibleFiles.isNotEmpty) {
        formMap['ProfilePicture'] = files;
      }
    }

    if (replyId != null) {
      formMap['ReplyId'] = replyId.toString();
    } else {
      formMap['ReplyId'] = '';
    }

    return FormData.fromMap(formMap);
  }

  @override
  String toString() {
    return 'ReplyCommentReq(replyId: $replyId, commentId: $commentId, content: $content, files: $files)';
  }
}
