import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:dio/dio.dart';

class ReplyCommentReq {
  final int? replyId;
  final int? commentId;
  final String content;
  final List<File>? mediaFiles; // Đặt là nullable vì có thể không có file

  ReplyCommentReq({
    this.replyId,
    required this.commentId,
    required this.content,
    this.mediaFiles,
  });

  // Phương thức để chuyển đổi thành FormData
  Future<FormData> toFormData() async {
    Map<String, dynamic> formMap = {
      'CommentId': commentId.toString(),
      'Content': content,
      'files': mediaFiles
    };
    if (mediaFiles != null && mediaFiles!.isNotEmpty) {
      List<MultipartFile> files = []; // 👈 Đặt trong block này

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
        formMap['files'] = files;
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
    return 'ReplyCommentReq(replyId: $replyId, commentId: $commentId, content: $content, files: $mediaFiles)';
  }
}
