import 'package:tracio_fe/domain/shop/entities/response/reply_review_entity.dart';

class ReplyReviewModel extends ReplyReviewEntity {
  ReplyReviewModel(
      {required super.replyId,
      required super.shopId,
      required super.shopPictureProfile,
      required super.shopName,
      required super.content,
      required super.isUpdated,
      required super.createdAt,
      required super.updatedAt});

  factory ReplyReviewModel.fromJson(Map<String, dynamic> json) {
    return ReplyReviewModel(
      replyId: json["replyId"],
      shopId: json["shopId"],
      shopPictureProfile: json["shopPictureProfile"],
      shopName: json["shopName"],
      content: json["content"],
      isUpdated: json["isUpdated"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "replyId": replyId,
        "shopId": shopId,
        "shopPictureProfile": shopPictureProfile,
        "shopName": shopName,
        "content": content,
        "isUpdated": isUpdated,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
