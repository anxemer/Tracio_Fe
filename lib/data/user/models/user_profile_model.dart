import 'package:Tracio/data/challenge/models/response/challenge_reward_model.dart';
import 'package:Tracio/domain/user/entities/user_profile_entity.dart';

class UserprofileModel extends UserProfileEntity {
  UserprofileModel({
    required super.userId,
    required super.userName,
    required super.email,
    required super.firebaseId,
    required super.phoneNumber,
    required super.profilePicture,
    required super.bio,
    required super.totalDistance,
    required super.totalDuration,
    required super.maxDayStreak,
    required super.dayStreak,
    required super.totalBlog,
    required super.followers,
    required super.followings,
    required super.totalRoute,
    required super.gender,
    required super.birthDate,
    required super.city,
    required super.district,
    required super.followStatus,
    required super.isActive,
    required super.isPublic,
    required super.createdAt,
    required super.updatedAt,
    required super.rewards,
  });
  factory UserprofileModel.fromJson(Map<String, dynamic> json) {
    return UserprofileModel(
      userId: json["userId"],
      userName: json["userName"],
      email: json["email"],
      firebaseId: json["firebaseId"],
      phoneNumber: json["phoneNumber"],
      profilePicture: json["profilePicture"],
      bio: json["bio"],
      totalDistance: json['totalDistance'] != null
          ? (json['totalDistance'] as num).toDouble()
          : null,
      totalDuration: json['totalDuration'] != null
          ? (json['totalDuration'] as num).toDouble()
          : null,
      maxDayStreak: json['maxDayStreak'] != null
          ? (json['maxDayStreak'] as num).toDouble()
          : null,
      dayStreak: json['dayStreak'] != null
          ? (json['dayStreak'] as num).toDouble()
          : null,
      totalBlog: json["totalBlog"],
      followers: json["followers"],
      followings: json["followings"],
      totalRoute: json["totalRoute"],
      gender: json["gender"],
      birthDate: json["birthDate"],
      city: json["city"],
      district: json["district"],
      isActive: json["isActive"],
      isPublic: json["isPublic"],
      followStatus: json["followStatus"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      rewards: json['rewards'] != null
          ? List<ChallengeRewardModel>.from(
              (json['rewards'] as List<dynamic>).map(
                (x) => ChallengeRewardModel.fromJson(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  // Map<String, dynamic> toJson() => {
  //       "userId": userId,
  //       "userName": userName,
  //       "email": email,
  //       "firebaseId": firebaseId,
  //       "phoneNumber": phoneNumber,
  //       "profilePicture": profilePicture,
  //       "bio": bio,
  //       "totalDistance": totalDistance,
  //       "totalDuration": totalDuration,
  //       "maxDayStreak": maxDayStreak,
  //       "dayStreak": dayStreak,
  //       "totalBlog": totalBlog,
  //       "followers": followers,
  //       "followings": followings,
  //       "totalRoute": totalRoute,
  //       "gender": gender,
  //       "birthDate": birthDate,
  //       "city": city,
  //       "district": district,
  //       "isActive": isActive,
  //       "isPublic": isPublic,
  //       "createdAt": createdAt?.toIso8601String(),
  //       "updatedAt": updatedAt?.toIso8601String(),
  //       "rewards": rewards.map((x) => x).toList(),
  //     };
}
