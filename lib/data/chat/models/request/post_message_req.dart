import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class PostMessageReq {
  String conversationId;
  String? content;
  int? blogId;
  int? routeId;
  int? receiverId;
  File? files;
  PostMessageReq({
    required this.conversationId,
    this.content,
    this.blogId,
    this.routeId,
    this.receiverId,
    this.files,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'conversationId': conversationId,
      if (content != null) 'content': content,
      if (blogId != null) 'blogId': blogId.toString(),
      if (routeId != null) 'routeId': routeId.toString(),
      if (receiverId != null) 'receiverId': receiverId.toString(),
    };
    if (files != null) {
      final extension =
          p.extension(files!.path).toLowerCase().replaceFirst('.', '');
      map['files'] = await MultipartFile.fromFile(files!.path,
          filename: files!.path.split('/').last,
          contentType: DioMediaType.parse('image/$extension'));
    }

    return FormData.fromMap(map);
  }
}
