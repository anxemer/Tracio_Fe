import 'package:Tracio/domain/user/entities/daily_activity_entity.dart';

class DailyActivityModel extends DailyActivityEntity {
  DailyActivityModel(
      {required super.cyclingActivityId,
      required super.userId,
      required super.userName,
      required super.userAvatarUrl,
      required super.activityDate,
      required super.totalDistance,
      required super.totalDuration,
      required super.totalElevationGain,
      required super.totalRides,
      required super.avgSpeed,
      required super.maxSpeed,
      required super.createdAt,
      required super.updatedAt});
  factory DailyActivityModel.empty() {
    return DailyActivityModel(
      cyclingActivityId: 0,
      userId: 0,
      userName: '',
      userAvatarUrl: '',
      activityDate: null,
      totalDistance: 0.0,
      totalDuration: 0,
      totalElevationGain: 0,
      totalRides: 0,
      avgSpeed: 0.0,
      maxSpeed: 0.0,
      createdAt: null,
      updatedAt: null,
    );
  }

  factory DailyActivityModel.fromJson(Map<String, dynamic> json) {
    return DailyActivityModel(
      cyclingActivityId: json["cyclingActivityId"],
      userId: json["userId"],
      userName: json["userName"],
      userAvatarUrl: json["userAvatarUrl"],
      activityDate: DateTime.tryParse(json["activityDate"] ?? ""),
      totalDistance: json['totalDistance'] != null
          ? (json['totalDistance'] as num).toDouble()
          : null,
      totalDuration: json["totalDuration"],
      totalElevationGain: json['totalElevationGain'] != null
          ? (json['totalElevationGain'] as num).toDouble()
          : null,
      totalRides: json["totalRides"],
      avgSpeed: json['avgSpeed'] != null
          ? (json['avgSpeed'] as num).toDouble()
          : null,
      maxSpeed: json['maxSpeed'] != null
          ? (json['maxSpeed'] as num).toDouble()
          : null,
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

  // Map<String, dynamic> toJson() => {
  //     "cyclingActivityId": cyclingActivityId,
  //     "userId": userId,
  //     "userName": userName,
  //     "userAvatarUrl": userAvatarUrl,
  //     "activityDate": "${activityDate.year.toString().padLeft(4'0')}-${activityDate.month.toString().padLeft(2'0')}-${activityDate.day.toString().padLeft(2'0')}",
  //     "totalDistance": totalDistance,
  //     "totalDuration": totalDuration,
  //     "totalElevationGain": totalElevationGain,
  //     "totalRides": totalRides,
  //     "avgSpeed": avgSpeed,
  //     "maxSpeed": maxSpeed,
  //     "createdAt": createdAt?.toIso8601String(),
  //     "updatedAt": updatedAt?.toIso8601String(),
  // };
}
