import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Tracio/domain/challenge/entities/challenge_reward.dart';

class ChallengeEntity {
  ChallengeEntity({
    required this.challengeId,
    required this.challengeThumbnail,
    required this.title,
    required this.description,
    required this.challengeType,
    required this.goalValue,
    this.totalParticipants, 
    required this.unit,
    required this.creatorId,
    required this.creatorName,
    required this.creatorAvatarUrl,
    required this.isSystem,
    required this.isPublic,
    required this.status,
    required this.progress,
    required this.challengeRank,
    required this.isCompleted,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.challengeRewardMappings,
  });

  final int? challengeId;
  final String challengeThumbnail;
  final String? title;
  final String? description;
  final String? challengeType;
  final int? goalValue;
  final String? unit;
  final int? creatorId;
  final String? creatorName;
  final String? creatorAvatarUrl;
  final bool? isSystem;
  final bool? isPublic;
  final String status;
  final double? progress;
  final int challengeRank;
  final int? totalParticipants;
  final bool? isCompleted;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? createdAt;
  final List<ChallengeRewardEntity> challengeRewardMappings;

   String get timeLeftDisplay {
    final now = DateTime.now();
    final currentStatus = status.toUpperCase();

    if (currentStatus == 'ENDED' || currentStatus == 'COMPLETED' || currentStatus == 'CANCELLED' || currentStatus == 'FAILED') {
      return "Finished";
    }

    if (endDate == null) {
       if (currentStatus == 'ACTIVE') {
         return "Ongoing";
      }
      return "No time limit";
    }

    if (startDate != null && now.isBefore(startDate!)) {
      final startDay = DateUtils.dateOnly(startDate!);
      final today = DateUtils.dateOnly(now);
      final daysToStart = startDay.difference(today).inDays;

      if (daysToStart == 0) {
        return "Starts today";
      } else if (daysToStart == 1) {
        return "Starts tomorrow";
      } else {
        return "Starts in $daysToStart days";
      }
    }

    final endDay = DateUtils.dateOnly(endDate!);
    final today = DateUtils.dateOnly(now);
    final daysRemaining = endDay.difference(today).inDays;

    if (daysRemaining < 0) {
      return "Overdue";
    } else if (daysRemaining == 0) {
      return "Last day";
    } else if (daysRemaining == 1) {
      return "1 day left";
    } else {
      return "$daysRemaining days left";
    }
  }
   String get startDateFormatted {
    if (startDate == null) return '';
    return DateFormat('dd/MM').format(startDate!);
  }

  String get endDateFormatted {
    if (endDate == null) return '';
    return DateFormat('dd/MM').format(endDate!);
  }
}