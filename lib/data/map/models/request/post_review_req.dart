import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class PostReviewReq {
  final int routeId;
  final List<int>? tagUserIds;
  final List<String>? tagUserNames;
  final String? content;
  final File? file;

  const PostReviewReq({
    required this.routeId,
    this.tagUserIds,
    this.tagUserNames,
    this.content,
    this.file,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'routeId': routeId,
      if (content != null) 'content': content,
      if (tagUserIds != null) 'tagUserIds': tagUserIds,
      if (tagUserNames != null) 'tagUserNames': tagUserNames,
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
