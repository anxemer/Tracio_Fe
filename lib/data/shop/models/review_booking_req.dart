// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:dio/dio.dart';

class ReviewBookingReq {
  final int bookingDetailId;
  final String content;
  final int rating;
  final List<File>? mediaFiles;
  ReviewBookingReq({
    required this.bookingDetailId,
    required this.content,
    required this.rating,
    this.mediaFiles,
  });

  Future<FormData> toFormData() async {
    List<MultipartFile> files = [];

    if (mediaFiles != null) {
      for (var file in mediaFiles!) {
        if (await file.exists()) {
          files.add(await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ));
        }
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
