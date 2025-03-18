// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GetRouteReq {
  final int pageNumber;
  final int rowsPerPage;
  final String? filterValue;
  final String? filterField;
  final String? sortField;
  final bool? sortDesc;
  GetRouteReq({
    required this.pageNumber,
    required this.rowsPerPage,
    this.filterValue,
    this.filterField,
    this.sortField,
    this.sortDesc,
  });

  GetRouteReq copyWith({
    int? pageNumber,
    int? rowsPerPage,
    String? filterValue,
    String? filterField,
    String? sortField,
    bool? sortDesc,
  }) {
    return GetRouteReq(
      pageNumber: pageNumber ?? this.pageNumber,
      rowsPerPage: rowsPerPage ?? this.rowsPerPage,
      filterValue: filterValue ?? this.filterValue,
      filterField: filterField ?? this.filterField,
      sortField: sortField ?? this.sortField,
      sortDesc: sortDesc ?? this.sortDesc,
    );
  }

  Map<String, String> toMap() {
    return <String, String>{
      'pageNumber': pageNumber.toString(),
      'rowsPerPage': rowsPerPage.toString(),
      'sortDesc': sortDesc.toString(),
    };
  }

  factory GetRouteReq.fromMap(Map<String, dynamic> map) {
    return GetRouteReq(
      pageNumber: map['pageNumber'] as int,
      rowsPerPage: map['rowsPerPage'] as int,
      filterValue:
          map['filterValue'] != null ? map['filterValue'] as String : null,
      filterField:
          map['filterField'] != null ? map['filterField'] as String : null,
      sortField: map['sortField'] != null ? map['sortField'] as String : null,
      sortDesc: map['sortDesc'] != null ? map['sortDesc'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetRouteReq.fromJson(String source) =>
      GetRouteReq.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GetRouteReq(pageNumber: $pageNumber, rowsPerPage: $rowsPerPage, filterValue: $filterValue, filterField: $filterField, sortField: $sortField, sortDesc: $sortDesc)';
  }
}
