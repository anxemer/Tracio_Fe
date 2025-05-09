import 'package:Tracio/domain/map/entities/matched_user.dart';

class MatchedUserModel extends MatchedUserEntity {
  MatchedUserModel({
    required super.userId,
    required super.userName,
    required super.avatar,
    required super.longitude,
    required super.latitude,
  });

  factory MatchedUserModel.fromMap(Map<String, dynamic> map) {
    return MatchedUserModel(
      userId: map['userId'] as int,
      userName: map['userName'] as String,
      avatar: map['avatar'] as String,
      longitude: map['longitude'] as double,
      latitude: map['latitude'] as double,
    );
  }
}

class UserMatchingModel {
  int userId;
  int routeId;
  int otherUserId;
  String otherUserName;
  String otherUserAvatar;
  int otherRouteId;
  UserMatchingModel({
    required this.userId,
    required this.routeId,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.otherRouteId,
  });

  factory UserMatchingModel.fromMap(Map<String, dynamic> map) {
    return UserMatchingModel(
      userId: map['userId'] as int,
      routeId: map['routeId'] as int,
      otherUserId: map['otherUserId'] as int,
      otherUserName: map['otherUserName'],
      otherUserAvatar: map['otherUserAvatar'],
      otherRouteId: map['otherRouteId'] as int,
    );
  }
}

class ApproveMatchModel {
  int userId;
  int routeId;
  int otherUserId;
  int otherRouteId;
  String status;
  ApproveMatchModel({
    required this.userId,
    required this.routeId,
    required this.otherUserId,
    required this.otherRouteId,
    required this.status,
  });

  factory ApproveMatchModel.fromMap(Map<String, dynamic> map) {
    return ApproveMatchModel(
      userId: map['userId'] as int,
      routeId: map['routeId'] as int,
      otherUserId: map['otherUserId'] as int,
      otherRouteId: map['otherRouteId'] as int,
      status: map['status'] as String,
    );
  }
}
