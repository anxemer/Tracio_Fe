import 'package:Tracio/domain/user/entities/follow_entity.dart';

class FollowModel extends FollowEntity {
  FollowModel(
      {required super.followerId,
      required super.followerName,
      required super.followerAvatarUrl,
      required super.status,
      required super.createdAt,
      required super.updatedAt});

  factory FollowModel.fromJson(Map<String, dynamic> json) {
    return FollowModel(
      followerId: json["followId"],
      followerName: json["followName"],
      followerAvatarUrl: json["followAvatarUrl"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "followId": followerId,
        "followName": followerName,
        "followAvatarUrl": followerAvatarUrl,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
