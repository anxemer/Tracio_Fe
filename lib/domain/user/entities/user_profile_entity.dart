// ignore_for_file: public_member_api_docs, sort_constructors_first
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
    this.followStatus,
    required this.rewards,
  });

  final int? userId;
  final String? userName;
  final String? email;
  final String? firebaseId;
  final dynamic phoneNumber;
  final String? profilePicture;
  final String? bio;
  final double? totalDistance;
  final double? totalDuration;
  final double? maxDayStreak;
  final double? dayStreak;
  final int? totalBlog;
  final int? followers;
  final int? followings;
  final int? totalRoute;
  final String? gender;
  final dynamic birthDate;
  final String? city;
  final String? district;
  final bool? isActive;
   bool? isPublic;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? followStatus;
  final List<ChallengeRewardEntity>? rewards;

    String formatDistanceFlexible() {
    if (totalDistance == null || totalDistance! <= 0) return '0 m';

    int totalMeters = (totalDistance! * 1000).round();
    int kilometers = totalMeters ~/ 1000;
    int meters = totalMeters % 1000;

    if (kilometers > 0 && meters > 0) {
      return '$kilometers km $meters m';
    } else if (kilometers > 0) {
      return '$kilometers km';
    } else {
      if (meters < 200) meters = 200;
      return '$meters m';
    }
  }
  String get formattedDuration {
    if (totalDuration == null) return "0h0m";
    final int seconds = totalDuration!.round();
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    return "${hours}h${minutes}m";
  }
}
