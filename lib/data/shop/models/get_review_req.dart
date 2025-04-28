import 'dart:convert';

class GetReviewReq {
  final int seriveId;
  final int pageSize;
  final int pageNumber;
  GetReviewReq({
   required this.seriveId,
    required this.pageSize,
    required this.pageNumber,
  });
  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};

    params['seriveId'] = seriveId.toString();
    params['pageSize'] = pageSize.toString();
    params['pageNumber'] = pageNumber.toString();

    return params;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'seriveId': seriveId,
      'pageSize': pageSize,
      'pageNumber': pageNumber,
    };
  }

  factory GetReviewReq.fromMap(Map<String, dynamic> map) {
    return GetReviewReq(
      seriveId: map['seriveId'] as int,
      pageSize: map['pageSize'] as int,
      pageNumber: map['pageNumber'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetReviewReq.fromJson(String source) =>
      GetReviewReq.fromMap(json.decode(source) as Map<String, dynamic>);
}
