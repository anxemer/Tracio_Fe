// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:Tracio/data/groups/models/response/vietnam_district_model.dart';

class VietnamCityModel {
  String name;
  int code;
  String divisionType;
  String codename;
  int phoneCode;
  List<VietnamDistrictModel> districts;
  VietnamCityModel({
    required this.name,
    required this.code,
    required this.divisionType,
    required this.codename,
    required this.phoneCode,
    required this.districts,
  });

  VietnamCityModel copyWith({
    String? name,
    int? code,
    String? divisionType,
    String? codename,
    int? phoneCode,
    List<VietnamDistrictModel>? districts,
  }) {
    return VietnamCityModel(
      name: name ?? this.name,
      code: code ?? this.code,
      divisionType: divisionType ?? this.divisionType,
      codename: codename ?? this.codename,
      phoneCode: phoneCode ?? this.phoneCode,
      districts: districts ?? this.districts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'code': code,
      'division_type': divisionType,
      'codename': codename,
      'phone_code': phoneCode,
      'districts': districts.map((x) => x.toMap()).toList(),
    };
  }

  factory VietnamCityModel.fromMap(Map<String, dynamic> map) {
    return VietnamCityModel(
      name: map['name'] as String,
      code: map['code'] as int,
      divisionType: map['division_type'] as String,
      codename: map['codename'] as String,
      phoneCode: map['phone_code'] as int,
      districts: List<VietnamDistrictModel>.from(
        (map['districts'] as List<dynamic>).map<VietnamDistrictModel>(
          (x) => VietnamDistrictModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory VietnamCityModel.fromJson(String source) =>
      VietnamCityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant VietnamCityModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.code == code &&
        other.divisionType == divisionType &&
        other.codename == codename &&
        other.phoneCode == phoneCode &&
        listEquals(other.districts, districts);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        code.hashCode ^
        divisionType.hashCode ^
        codename.hashCode ^
        phoneCode.hashCode ^
        districts.hashCode;
  }
}
