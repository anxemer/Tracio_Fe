// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:dio/dio.dart';

class CreateServiceReq {
  final int shopId;
  final int categoryId;
  final String nameService;
  final String description;
  final double price;
  final String duration;
  final List<File> mediaFiles;
  CreateServiceReq({
    required this.shopId,
    required this.categoryId,
    required this.nameService,
    required this.description,
    required this.price,
    required this.duration,
    required this.mediaFiles,
  });
  Future<FormData> toFormData() async {
    List<MultipartFile> files = [];

    for (var file in mediaFiles) {
      if (await file.exists()) {
        final image =
            p.extension(file.path).toLowerCase().replaceFirst('.', '');
        files.add(await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last,
            contentType: DioMediaType.parse('image/$image')));
      } else {
        print("⚠️ File không tồn tại: ${file.path}");
      }
    }

    return FormData.fromMap({
      'ShopId': shopId.toString(), // ép sang chuỗi nếu API cần string
      'CategoryId': categoryId.toString(),
      'Name': nameService,
      'Description': description,
      'Price': price.toString(), // nếu cần string
      'Duration': duration,
      'Files': mediaFiles, // tên key 'Files' cần đúng với phía API
    });
  }

  String formatDuration(int minutes) {
    final d = Duration(minutes: minutes);
    // Format HH:mm:ss
    final hours = d.inHours.toString().padLeft(2, '0');
    final mins = (d.inMinutes % 60).toString().padLeft(2, '0');
    final secs = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$mins:$secs";
  }
}
