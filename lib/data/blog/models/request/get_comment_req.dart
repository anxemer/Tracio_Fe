// ignore_for_file: public_member_api_docs, sort_constructors_first
class GetCommentReq {
  final int blogId;
  final int? commentId;
  final int? pageSize;
  final int? pageNumber;
  GetCommentReq({
    required this.blogId,
    this.commentId,
    this.pageSize,
    this.pageNumber,
  });
}
