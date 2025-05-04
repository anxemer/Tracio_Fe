import '../../../../common/helper/media_file.dart';

class ReviewDetailEntity {
  ReviewDetailEntity({
    required this.reviewId,
    required this.cyclistId,
    required this.cyclistName,
    required this.cyclistAvatar,
    required this.content,
    required this.rating,
    required this.isUpdated,
    required this.createdAt,
    required this.updatedAt,
    required this.mediaFile,
  });

  final int? reviewId;
  final int? cyclistId;
  final String? cyclistName;
  final String? cyclistAvatar;
  final String? content;
  final int? rating;
  final bool? isUpdated;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final MediaFile mediaFile;
}
