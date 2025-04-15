// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class VietnamDistrictModel {
  String name;
  int code;
  String divisionType;
  String codename;
  int provinceCode;
  List<dynamic> wards;
  VietnamDistrictModel({
    required this.name,
    required this.code,
    required this.divisionType,
    required this.codename,
    required this.provinceCode,
    required this.wards,
  });

  VietnamDistrictModel copyWith({
    String? name,
    int? code,
    String? divisionType,
    String? codename,
    int? provinceCode,
    List<dynamic>? wards,
  }) {
    return VietnamDistrictModel(
      name: name ?? this.name,
      code: code ?? this.code,
      divisionType: divisionType ?? this.divisionType,
      codename: codename ?? this.codename,
      provinceCode: provinceCode ?? this.provinceCode,
      wards: [],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'code': code,
      'division_type': divisionType,
      'codename': codename,
      'province_code': provinceCode,
      'wards': [],
    };
  }

  factory VietnamDistrictModel.fromMap(Map<String, dynamic> map) {
    return VietnamDistrictModel(
        name: map['name'] as String,
        code: map['code'] as int,
        divisionType: map['division_type'] as String,
        codename: map['codename'] as String,
        provinceCode: map['province_code'] as int,
        wards: []);
  }

  String toJson() => json.encode(toMap());

  factory VietnamDistrictModel.fromJson(String source) =>
      VietnamDistrictModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant VietnamDistrictModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.code == code &&
        other.divisionType == divisionType &&
        other.codename == codename &&
        other.provinceCode == provinceCode &&
        listEquals(other.wards, wards);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        code.hashCode ^
        divisionType.hashCode ^
        codename.hashCode ^
        provinceCode.hashCode ^
        wards.hashCode;
  }
}
