import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GetBlogReq {
  final int userRequestId;
  final int userId;
  final DateTime sortBy;
  final bool ascending;

  GetBlogReq({
    required this.userRequestId,
    required this.userId,
    required this.sortBy,
    required this.ascending,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userRequestId': userRequestId,
      'userId': userId,
      'createAt': sortBy.millisecondsSinceEpoch.toString(),
      'ascending': ascending,
    };
  }

  factory GetBlogReq.fromMap(Map<String, dynamic> map) {
    return GetBlogReq(
      userRequestId: map['userRequestId'] as int,
      userId: map['userId'] as int,
      sortBy: DateTime.fromMillisecondsSinceEpoch(map['createAt'] as int),
      ascending: map['ascending'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetBlogReq.fromJson(String source) =>
      GetBlogReq.fromMap(json.decode(source) as Map<String, dynamic>);
}
