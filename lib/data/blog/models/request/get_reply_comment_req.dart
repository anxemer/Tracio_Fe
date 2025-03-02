// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';

class GetReplyCommentReq {
  final int commentId;
  final int replyId;
  final int pageSize;
  final int pageNumber;
  GetReplyCommentReq({
    required this.commentId,
   required  this.replyId,
   required this.pageSize,
   required this.pageNumber,
  });

  Future<FormData> toFormData() async {
    // Kiểm tra null cho mediaFiles

    return FormData.fromMap({
      'commentId': commentId.toString(),
      'replyId': replyId,
      'pageNumber': pageNumber,
      'pageSize': pageSize
    });
  }
}
