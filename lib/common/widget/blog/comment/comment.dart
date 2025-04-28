abstract class BaseCommentEntity {
  int commentId;
  int userId;
  String userName;
  String userAvatar;
  DateTime createdAt;
  bool isReacted;
  String content;
  List<String> tagUserNames;
  List<String> mediaUrls;
  int likeCount;
  int replyCount;
  BaseCommentEntity({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.createdAt,
    required this.isReacted,
    required this.content,
    required this.tagUserNames,
    required this.mediaUrls,
    required this.likeCount,
    required this.replyCount,
  });
}
