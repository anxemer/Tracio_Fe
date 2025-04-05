// ignore_for_file: public_member_api_docs, sort_constructors_first
class GetBookingReq {
  final String? specificDate;
  final String? startDate;
  final String? endDate;
  final String? status;

  final int pageNumber;
  final int pageSize;
  GetBookingReq({
    this.specificDate,
    this.startDate,
    this.endDate,
    this.status,
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (specificDate != null) data['specificDate'] = specificDate;
    if (status != null) data['status'] = status;
    if (startDate != null) data['startDate'] = startDate;
    if (endDate != null) data['endDate'] = endDate;
    // if (pageNumber != null) data['pageNumber'] = pageNumber;
    // if (pageSize != null) data['pageSize'] = pageSize;

    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;

    return data;
  }

  GetBookingReq copyWith({
    String? specificDate,
    String? startDate,
    String? endDate,
    String? status,
    int? pageNumber,
    int? pageSize,
  }) {
    return GetBookingReq(
      specificDate: specificDate,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  Map<String, String> toQueryParams() {
    final Map<String, String> params = {};

    // Chỉ thêm các trường không null vào request
    if (specificDate != null) params['specificDate'] = specificDate.toString();
    if (status != null) params['status'] = status!;
    if (startDate != null) params['startDate'] = startDate!;
    if (endDate != null) params['endDate'] = endDate.toString();

    params['pageNumber'] = pageNumber.toString();
    params['pageSize'] = pageSize.toString();

    return params;
  }
}
