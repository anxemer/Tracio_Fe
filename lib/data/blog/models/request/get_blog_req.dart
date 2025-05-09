// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

class GetBlogReq {
  GetBlogReq({
    this.userId,
    this.categoryId,
    this.sortBy,
    this.ascending,
    this.isSeen,
    this.pageSize,
    this.pageNumber,
  });

  final String? userId;
  final String? categoryId;
  final String? sortBy;
  final String? ascending;
  final bool? isSeen;
  final int? pageSize;
  final int? pageNumber;

  // factory GetBlogReq.fromJson(Map<String, dynamic> json) {
  //   return GetBlogReq(
  //     userId: json["userId"],
  //     categoryId: json["categoryId"],
  //     sortBy: (json["sortBy"] ?? ""),
  //     isSeen: (json["isSeen"] ?? ""),
  //     ascending: json["ascending"],
  //     pageSize: json["pageSize"],
  //     pageNumber: json["pageNumber"],
  //   );
  // }

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "categoryId": categoryId,
        "sortBy": sortBy,
        "isSeen": isSeen,
        "ascending": ascending,
        "pageSize": pageSize,
        "pageNumber": pageNumber,
      };
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      "userId": userId,
      "categoryId": categoryId,
      "sortBy": sortBy,
      "ascending": ascending,
      "pageSize": pageSize,
      "pageNumber": pageNumber,
    });
  }

  Map<String, String> toQueryParams() {
    return {
      if (userId != null) 'userId': userId!,
      if (categoryId != null) 'categoryId': categoryId!,
      if (isSeen != null) 'isSeen': isSeen.toString(),
      if (sortBy != null) 'sortBy': sortBy!,
      if (ascending != null) 'ascending': ascending!,
      if (pageSize != null) 'pageSize': pageSize.toString(),
      if (pageNumber != null) 'pageNumber': pageNumber.toString(),
    };
  }
}
