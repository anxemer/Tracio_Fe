class GetGroupParticipantReq {
  int groupId;
  int rowsPerPage;
  int pageNumber;
  String sortField;
  bool sortDesc;
  String? filterField;
  String? filterValue;

  GetGroupParticipantReq({
    required this.groupId,
    this.rowsPerPage = 10,
    this.pageNumber = 1,
    this.sortField = "JoinAt",
    this.sortDesc = false,
    this.filterField,
    this.filterValue,
  });

  Map<String, String> toQueryParam() {
    final map = {
      "rowsPerPage": rowsPerPage.toString(),
      "pageNumber": pageNumber.toString(),
      "sortField": sortField,
      "sortDesc": sortDesc.toString(),
    };

    if (filterField != null && filterValue != null) {
      map["filterField"] = filterField!;
      map["filterValue"] = filterValue!;
    }

    return map;
  }
}
