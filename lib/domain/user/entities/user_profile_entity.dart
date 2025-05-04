import '../../challenge/entities/challenge_reward.dart';

class UserProfileEntity {
    UserProfileEntity({
        required this.userId,
        required this.userName,
        required this.email,
        required this.firebaseId,
        required this.phoneNumber,
        required this.profilePicture,
        required this.bio,
        required this.totalDistance,
        required this.totalDuration,
        required this.maxDayStreak,
        required this.dayStreak,
        required this.totalBlog,
        required this.followers,
        required this.followings,
        required this.totalRoute,
        required this.gender,
        required this.birthDate,
        required this.city,
        required this.district,
        required this.isActive,
        required this.isPublic,
        required this.createdAt,
        required this.updatedAt,
        required this.rewards,
    });

    final int? userId;
    final String? userName;
    final String? email;
    final String? firebaseId;
    final dynamic phoneNumber;
    final String? profilePicture;
    final String? bio;
    final int? totalDistance;
    final int? totalDuration;
    final int? maxDayStreak;
    final int? dayStreak;
    final int? totalBlog;
    final int? followers;
    final int? followings;
    final int? totalRoute;
    final String? gender;
    final dynamic birthDate;
    final String? city;
    final String? district;
    final bool? isActive;
    final bool? isPublic;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final List<ChallengeRewardEntity> rewards;

   

}
