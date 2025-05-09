class DailyActivityEntity {
  DailyActivityEntity({
    required this.cyclingActivityId,
    required this.userId,
    required this.userName,
    required this.userAvatarUrl,
    required this.activityDate,
    required this.totalDistance,
    required this.totalDuration,
    required this.totalElevationGain,
    required this.totalRides,
    required this.avgSpeed,
    required this.maxSpeed,
    required this.createdAt,
    required this.updatedAt,
  });

  final int? cyclingActivityId;
  final int? userId;
  final String? userName;
  final String? userAvatarUrl;
  final DateTime? activityDate;
  final double? totalDistance;
  final int? totalDuration;
  final int? totalElevationGain;
  final int? totalRides;
  final double? avgSpeed;
  final double? maxSpeed;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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

  String formatDuration() {
    if (totalDuration == null || totalDuration! <= 0) return '0 minutes';

    int hours = totalDuration! ~/ 3600;
    int minutes = (totalDuration! % 3600) ~/ 60;

    if (hours > 0 && minutes > 0) {
      return '$hours hours $minutes minutes';
    } else if (hours > 0) {
      return '$hours hours';
    } else {
      return '$minutes minutes';
    }
  }
}
