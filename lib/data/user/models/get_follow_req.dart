// ignore_for_file: public_member_api_docs, sort_constructors_first
class GetFollowReq {
  final int? userId;
  final int? pageNumber;
  final int? pageSize;
  GetFollowReq({
    this.userId,
    this.pageNumber,
    this.pageSize,
  });

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};

    params['pageNumber'] = pageNumber.toString();

    return params;
  }
}
