class GetGroupListReq {
  final int pageNumber;
  final int pageSize;
  final String? filterValue;
  final String? searchName;
  final String? location;
  final String? filterField;
  final String? sortField;
  final bool? sortDesc;
  final bool? getMyGroups;
  GetGroupListReq({
    required this.pageNumber,
    required this.pageSize,
    this.filterValue,
    this.searchName,
    this.location,
    this.filterField,
    this.sortField,
    this.sortDesc,
    this.getMyGroups,
  });

  GetGroupListReq copyWith({
    int? pageNumber,
    int? pageSize,
    String? filterValue,
    String? searchName,
    String? location,
    String? filterField,
    String? sortField,
    bool? sortDesc,
    bool? getMyGroups,
  }) {
    return GetGroupListReq(
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      filterValue: filterValue ?? this.filterValue,
      searchName: searchName ?? this.searchName,
      location: location ?? this.location,
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
      'searchName': searchName,
      'cityOrDistrict': location,
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
      if (searchName != null) 'searchName': searchName!,
      if (location != null) 'cityOrDistrict': location!,
    };
  }
}
