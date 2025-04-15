// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:tracio_fe/data/groups/models/response/group_rep.dart';

class GetGroupListRep {
  List<GroupResponseModel> groupList;
  int totalCount;
  int pageNumber;
  int pageSize;
  int totalPages;
  bool hasPreviousPage;
  bool hasNextPage;
  GetGroupListRep({
    required this.groupList,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  GetGroupListRep copyWith({
    List<GroupResponseModel>? groupList,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPages,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return GetGroupListRep(
      groupList: groupList ?? this.groupList,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'groupList': groupList.map((x) => x.toMap()).toList(),
      'totalCount': totalCount,
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }

  factory GetGroupListRep.fromMap(Map<String, dynamic> map) {
    return GetGroupListRep(
      groupList: List<GroupResponseModel>.from(
        (map['items'] as List<dynamic>).map<GroupResponseModel>(
          (x) => GroupResponseModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      totalCount: map['totalCount'] as int,
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      totalPages: map['totalPages'] as int,
      hasPreviousPage: map['hasPreviousPage'] as bool,
      hasNextPage: map['hasNextPage'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetGroupListRep.fromJson(String source) =>
      GetGroupListRep.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetGroupListRep(groupList: $groupList, totalCount: $totalCount, pageNumber: $pageNumber, pageSize: $pageSize, totalPages: $totalPages, hasPreviousPage: $hasPreviousPage, hasNextPage: $hasNextPage)';
  }

  @override
  bool operator ==(covariant GetGroupListRep other) {
    if (identical(this, other)) return true;

    return listEquals(other.groupList, groupList) &&
        other.totalCount == totalCount &&
        other.pageNumber == pageNumber &&
        other.pageSize == pageSize &&
        other.totalPages == totalPages &&
        other.hasPreviousPage == hasPreviousPage &&
        other.hasNextPage == hasNextPage;
  }

  @override
  int get hashCode {
    return groupList.hashCode ^
        totalCount.hashCode ^
        pageNumber.hashCode ^
        pageSize.hashCode ^
        totalPages.hashCode ^
        hasPreviousPage.hashCode ^
        hasNextPage.hashCode;
  }
}
