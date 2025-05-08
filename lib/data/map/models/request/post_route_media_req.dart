import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class PostRouteMediaReq {
  int routeId;
  File mediaFile;
  double? latitude;
  double? longitude;
  double? altitude;
  PostRouteMediaReq({
    required this.routeId,
    required this.mediaFile,
    this.latitude,
    this.longitude,
    this.altitude,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> map = {
      'Latitude': latitude ?? 0,
      'Longitude': longitude ?? 0,
      'Altitude': altitude ?? 0,
    };

    final fileName = p.basename(mediaFile.path);
    final extension = p.extension(fileName).toLowerCase().replaceFirst('.', '');
    final mimeType = 'image/$extension';

    map['MediaFile'] = await MultipartFile.fromFile(
      mediaFile.path,
      filename: fileName,
      contentType: DioMediaType.parse(mimeType),
    );
    return FormData.fromMap(map);
  }
}
