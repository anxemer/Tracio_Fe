// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class CreateShopProfileReq {
  final String? contactNumber;
  final String? shopName;
  final String? taxCode;
  final String? address;
  final List<File>? profilePicture;
  final String? city;
  final String? district;
  final double? latitude;
  final double? longitude;
  final String? openTime;
  final String? closedTime;
  CreateShopProfileReq({
    required this.contactNumber,
    required this.shopName,
    required this.taxCode,
    required this.address,
    required this.profilePicture,
    required this.city,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.openTime,
    required this.closedTime,
  });

  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {
      'ContactNumber': contactNumber,
      'ShopName': shopName,
      'TaxCode': taxCode,
      'Address': address,
      'City': city,
      'District': district,
      'Latitude': latitude.toString(),
      'Longitude': longitude.toString(),
      'OpenTime': openTime,
      'ClosedTime': closedTime,
    };

    if (profilePicture != null && profilePicture!.isNotEmpty) {
      List<MultipartFile> files = [];
      for (var file in profilePicture!) {
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
        data['ProfilePicture'] = files;
      }
    }

    return FormData.fromMap(data);
  }
}
