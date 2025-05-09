class ReplyReviewEntity {
    ReplyReviewEntity({
        required this.replyId,
        required this.shopId,
        required this.shopPictureProfile,
        required this.shopName,
        required this.content,
        required this.isUpdated,
        required this.createdAt,
        required this.updatedAt,
    });

    final int? replyId;
    final int? shopId;
    final String? shopPictureProfile;
    final String? shopName;
    final String? content;
    final bool? isUpdated;
    final DateTime? createdAt;
    final DateTime? updatedAt;

   

}
