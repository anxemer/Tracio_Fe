import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class PostReplyReq {
  final int reviewId;
  final int? replyId;
  final String? content;
  final File? file;

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

    if (file != null) {
      final fileName = p.basename(file!.path);
      final extension =
          p.extension(fileName).toLowerCase().replaceFirst('.', '');
      final mimeType = 'image/$extension';

      map['files'] = await MultipartFile.fromFile(
        file!.path,
        filename: fileName,
        contentType: DioMediaType.parse(mimeType),
      );
    }

    return FormData.fromMap(map);
  }
}
