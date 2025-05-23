// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetGroupListReq {
  final int pageNumber;
  final int pageSize;
  final String? filterValue;
  final String? filterField;
  final String? sortField;
  final bool? sortDesc;
  final bool? getMyGroups;
  GetGroupListReq({
    required this.pageNumber,
    required this.pageSize,
    this.filterValue,
    this.filterField,
    this.sortField,
    this.sortDesc,
    this.getMyGroups,
  });

  GetGroupListReq copyWith({
    int? pageNumber,
    int? pageSize,
    String? filterValue,
    String? filterField,
    String? sortField,
    bool? sortDesc,
    bool? getMyGroups,
  }) {
    return GetGroupListReq(
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      filterValue: filterValue ?? this.filterValue,
      filterField: filterField ?? this.filterField,
      sortField: sortField ?? this.sortField,
      sortDesc: sortDesc ?? this.sortDesc,
      getMyGroups: getMyGroups ?? this.getMyGroups,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'filterValue': filterValue,
      'filterField': filterField,
      'sortField': sortField,
      'sortDesc': sortDesc,
      'getMyGroups': getMyGroups,
    };
  }

  Map<String, String> toQueryParams() {
    return {
      if (sortField != null) 'sortField': sortField!,
      if (sortDesc != null) 'sortDesc': sortDesc.toString(),
      if (filterField != null) 'filterField': filterField!,
      if (filterValue != null) 'filterValue': filterValue!,
      'pageSize': pageSize.toString(),
      'pageNumber': pageNumber.toString(),
      if (getMyGroups != null) 'getMyGroups': getMyGroups.toString(),
    };
  }

  factory GetGroupListReq.fromMap(Map<String, dynamic> map) {
    return GetGroupListReq(
      pageNumber: map['pageNumber'] as int,
      pageSize: map['pageSize'] as int,
      filterValue:
          map['filterValue'] != null ? map['filterValue'] as String : null,
      filterField:
          map['filterField'] != null ? map['filterField'] as String : null,
      sortField: map['sortField'] != null ? map['sortField'] as String : null,
      sortDesc: map['sortDesc'] != null ? map['sortDesc'] as bool : null,
      getMyGroups:
          map['getMyGroups'] != null ? map['getMyGroups'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetGroupListReq.fromJson(String source) =>
      GetGroupListReq.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetGroupListReq(pageNumber: $pageNumber, pageSize: $pageSize, filterValue: $filterValue, filterField: $filterField, sortField: $sortField, sortDesc: $sortDesc)';
  }

  @override
  bool operator ==(covariant GetGroupListReq other) {
    if (identical(this, other)) return true;

    return other.pageNumber == pageNumber &&
        other.pageSize == pageSize &&
        other.filterValue == filterValue &&
        other.filterField == filterField &&
        other.sortField == sortField &&
        other.sortDesc == sortDesc &&
        other.getMyGroups == getMyGroups;
  }

  @override
  int get hashCode {
    return pageNumber.hashCode ^
        pageSize.hashCode ^
        filterValue.hashCode ^
        filterField.hashCode ^
        sortField.hashCode ^
        sortDesc.hashCode ^
        getMyGroups.hashCode;
  }
}
