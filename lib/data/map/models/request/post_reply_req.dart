import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class PostReplyReq {
  final int reviewId;
  final int? replyId;
  final String? content;
  final List<File>? file;

  PostReplyReq({
    required this.reviewId,
    this.replyId,
    this.content,
    this.file,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'reviewId': reviewId,
      if (replyId != null) 'replyId': replyId,
      if (content != null) 'content': content,
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
        map['files'] = files;
      }
    }
    return FormData.fromMap(map);
  }
}
