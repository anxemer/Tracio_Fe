// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:dio/dio.dart';

class ReviewBookingReq {
  final int bookingDetailId;
  final String content;
  final int rating;
  final List<File> mediaFiles;
  ReviewBookingReq({
    required this.bookingDetailId,
    required this.content,
    required this.rating,
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
      'BookingDetailId': bookingDetailId.toString(),
      'Content': content,
      'Rating': rating.toString(),
      'files': files,
    });
  }
}
