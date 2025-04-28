// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CreateShopProfileEntity {
   final String? contactNumber;
  final String? shopName;
  final String? taxCode;
  final String? address;
  final String? profilePictureUrl; // URL ảnh hiện có
  final String? city;
  final String? district;
  final TimeOfDay? openTime;
  final TimeOfDay? closeTime;
  CreateShopProfileEntity({
    this.contactNumber,
    this.shopName,
    this.taxCode,
    this.address,
    this.profilePictureUrl,
    this.city,
    this.district,
    this.openTime,
    this.closeTime,
  });
}
