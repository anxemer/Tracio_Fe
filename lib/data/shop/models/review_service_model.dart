import 'package:tracio_fe/data/shop/models/reply_review_model.dart';
import 'package:tracio_fe/domain/shop/entities/response/review_service_entity.dart';

import '../../../common/helper/media_file.dart';
import '../../../domain/shop/entities/response/reply_review_entity.dart';

class ReviewServiceModel extends ReviewServiceEntity {
  ReviewServiceModel(
      {required super.reviewId,
      required super.cyclistId,
      required super.cyclistName,
      required super.cyclistAvatar,
      required super.content,
      required super.rating,
      required super.isUpdated,
      required super.createdAt,
      required super.updatedAt,
      required super.mediaFiles,
      required super.reply});
  ReviewServiceEntity copyWith({
    int? reviewId,
    int? cyclistId,
    String? cyclistName,
    String? cyclistAvatar,
    String? content,
    double? rating,
    bool? isUpdated,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MediaFile>? mediaFiles,
    ReplyReviewEntity? reply,
  }) {
    return ReviewServiceEntity(
        reviewId: reviewId ?? this.reviewId,
        cyclistId: cyclistId ?? this.cyclistId,
        cyclistName: cyclistName ?? this.cyclistName,
        cyclistAvatar: cyclistAvatar ?? this.cyclistAvatar,
        content: content ?? this.content,
        rating: rating ?? this.rating,
        isUpdated: isUpdated ?? this.isUpdated,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        mediaFiles: mediaFiles ?? this.mediaFiles,
        reply: reply);
  }

  factory ReviewServiceModel.fromJson(Map<String, dynamic> json) {
    return ReviewServiceModel(
      reviewId: json["reviewId"],
      cyclistId: json["cyclistId"],
      cyclistName: json["cyclistName"],
      cyclistAvatar: json["cyclistAvatar"],
      content: json["content"],
      rating:
          json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      isUpdated: json["isUpdated"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt:
          json["updatedAt"] != null && json["updatedAt"].toString().isNotEmpty
              ? DateTime.tryParse(json["updatedAt"])
              : null,
      mediaFiles: json["mediaFiles"] == null
          ? []
          : List<MediaFile>.from(
              json["mediaFiles"].map((x) => MediaFile.fromJson(x)),
            ),
      reply: json["reply"] != null
          ? ReplyReviewModel.fromJson(json["reply"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "reviewId": reviewId,
        "cyclistId": cyclistId,
        "cyclistName": cyclistName,
        "cyclistAvatar": cyclistAvatar,
        "content": content,
        "rating": rating,
        "isUpdated": isUpdated,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "mediaFiles": mediaFiles.map((x) => x).toList(),
        "reply": reply,
      };
}
