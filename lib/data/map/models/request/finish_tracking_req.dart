// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class FinishTrackingReq {
  int routeId;
  File? files;
  FinishTrackingReq({
    required this.routeId,
    this.files,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'RouteId': routeId.toString(),
    };
    if (files != null) {
      final extension =
          p.extension(files!.path).toLowerCase().replaceFirst('.', '');
      map['Thumbnail'] = await MultipartFile.fromFile(files!.path,
          filename: files!.path.split('/').last,
          contentType: DioMediaType.parse('image/$extension'));
    }

    return FormData.fromMap(map);
  }
}
