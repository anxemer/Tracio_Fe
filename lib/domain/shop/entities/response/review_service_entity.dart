import 'package:tracio_fe/common/helper/media_file.dart';
import 'package:tracio_fe/domain/blog/entites/reply_comment.dart';
import 'package:tracio_fe/domain/shop/entities/response/reply_review_entity.dart';

class ReviewServiceEntity {
    ReviewServiceEntity({
        required this.reviewId,
        required this.cyclistId,
        required this.cyclistName,
        required this.cyclistAvatar,
        required this.content,
        required this.rating,
        required this.isUpdated,
        required this.createdAt,
        required this.updatedAt,
        required this.mediaFiles,
        required this.reply,
    });

    final int? reviewId;
    final int? cyclistId;
    final String? cyclistName;
    final String? cyclistAvatar;
    final String? content;
    final double? rating;
    final bool? isUpdated;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<MediaFile> mediaFiles;
    final ReplyReviewEntity? reply;

    
}
