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
}
