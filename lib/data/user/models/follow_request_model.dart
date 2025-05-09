import 'package:Tracio/domain/user/entities/follow_request_entity.dart';

class FollowRequestModel extends FollowRequestEntity {
  FollowRequestModel(
      {required super.followerId,
      required super.followerName,
      required super.followerAvatarUrl,
      required super.status,
      required super.createdAt,
      required super.updatedAt});

  factory FollowRequestModel.fromJson(Map<String, dynamic> json) {
    return FollowRequestModel(
      followerId: json["followerId"],
      followerName: json["followerName"],
      followerAvatarUrl: json["followerAvatarUrl"],
      status: json["status"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "followerId": followerId,
        "followerName": followerName,
        "followerAvatarUrl": followerAvatarUrl,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
