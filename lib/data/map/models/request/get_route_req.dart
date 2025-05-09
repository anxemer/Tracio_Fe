class GetRouteReq {
  final int pageNumber;
  final int pageSize;
  final Map<String, String>? params;
  GetRouteReq({
    required this.pageNumber,
    required this.pageSize,
    this.params,
  });

  Map<String, String> toQueryParams() {
    return {
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
      ...?params,
    };
  }
}
