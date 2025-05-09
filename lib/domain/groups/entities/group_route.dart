// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'package:Tracio/data/map/models/route_blog.dart';
import 'package:Tracio/domain/map/entities/route_blog.dart';

class GroupRouteEntity {
  final int groupRouteId;
  final int routeId;
  final int groupId;
  final String title;
  final String description;
  final DateTime startDateTime;
  final String addressMeeting;
  final Position address;
  final String groupStatus;
  final int totalCheckIn;
  final String groupCheckinStatus; //NotStated, OnGoing, Finished, Deleted
  final List<Participant> participants;
  final int? ridingRouteId;
  final RouteBlogEntity? ridingRoute;
  final int creatorId;
  final String creatorName;
  final String creatorAvatarUrl;
  final List<GroupRouteDetail> groupRouteDetails;

  GroupRouteEntity({
    required this.groupRouteId,
    required this.routeId,
    required this.groupId,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.addressMeeting,
    required this.address,
    required this.groupStatus,
    required this.totalCheckIn,
    required this.groupCheckinStatus,
    required this.participants,
    required this.ridingRouteId,
    required this.ridingRoute,
    required this.creatorId,
    required this.creatorName,
    required this.creatorAvatarUrl,
    required this.groupRouteDetails,
  });

  String get formattedDate =>
      "${startDateTime.day}-${startDateTime.month}-${startDateTime.year}";

  String get formattedTime => "${startDateTime.hour}:${startDateTime.minute}";

  GroupRouteEntity copyWith({
    int? groupRouteId,
    int? routeId,
    int? groupId,
    String? title,
    String? description,
    DateTime? startDateTime,
    String? addressMeeting,
    Position? address,
    String? groupStatus,
    int? totalCheckIn,
    String? groupCheckinStatus,
    List<Participant>? participants,
    int? ridingRouteId,
    RouteBlogEntity? ridingRoute,
    int? creatorId,
    String? creatorName,
    String? creatorAvatarUrl,
    List<GroupRouteDetail>? groupRouteDetails,
  }) {
    return GroupRouteEntity(
      groupRouteId: groupRouteId ?? this.groupRouteId,
      routeId: routeId ?? this.routeId,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      startDateTime: startDateTime ?? this.startDateTime,
      addressMeeting: addressMeeting ?? this.addressMeeting,
      address: address ?? this.address,
      groupStatus: groupStatus ?? this.groupStatus,
      totalCheckIn: totalCheckIn ?? this.totalCheckIn,
      groupCheckinStatus: groupCheckinStatus ?? this.groupCheckinStatus,
      participants: participants ?? this.participants,
      ridingRouteId: ridingRouteId ?? this.ridingRouteId,
      ridingRoute: ridingRoute ?? this.ridingRoute,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      creatorAvatarUrl: creatorAvatarUrl ?? this.creatorAvatarUrl,
      groupRouteDetails: groupRouteDetails ?? this.groupRouteDetails,
    );
  }
}

class Participant {
  int cyclistId;
  String cyclistName;
  String cyclistAvatarUrl;
  bool isOrganizer;
  DateTime joinAt;
  String followStatus;
  Participant(
      {required this.cyclistId,
      required this.cyclistName,
      required this.cyclistAvatarUrl,
      required this.isOrganizer,
      required this.joinAt,
      required this.followStatus});

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      cyclistId: map['cyclistId'] as int,
      cyclistName: map['cyclistName'] as String,
      cyclistAvatarUrl: map['cyclistAvatarUrl'] as String,
      isOrganizer: map['isOrganizer'] as bool,
      joinAt: DateTime.parse(map['joinAt'] as String),
      followStatus: map['followStatus'] as String,
    );
  }

  String get formattedDate {
    return "${joinAt.day}-${joinAt.month}-${joinAt.year}";
  }

  String get formattedTime {
    return "${joinAt.hour}:${joinAt.minute}";
  }
}

class GroupRouteDetail {
  final int groupRouteDetailId;
  final int ridingRouteId;
  DateTime checkInAt;
  Cyclist cyclist;
  RouteBlogEntity ridingRoute;
  GroupRouteDetail({
    required this.groupRouteDetailId,
    required this.ridingRouteId,
    required this.checkInAt,
    required this.cyclist,
    required this.ridingRoute,
  });

  GroupRouteDetail copyWith({
    int? groupRouteDetailId,
    int? ridingRouteId,
    DateTime? checkInAt,
    Cyclist? cyclist,
    RouteBlogEntity? ridingRoute,
  }) {
    return GroupRouteDetail(
      groupRouteDetailId: groupRouteDetailId ?? this.groupRouteDetailId,
      ridingRouteId: ridingRouteId ?? this.ridingRouteId,
      checkInAt: checkInAt ?? this.checkInAt,
      cyclist: cyclist ?? this.cyclist,
      ridingRoute: ridingRoute ?? this.ridingRoute,
    );
  }

  factory GroupRouteDetail.fromMap(Map<String, dynamic> map) {
    return GroupRouteDetail(
      groupRouteDetailId: map['groupRouteDetailId'] as int,
      ridingRouteId: map['ridingRouteId'] as int,
      checkInAt: DateTime.parse(map['checkInAt'] as String),
      cyclist: Cyclist.fromMap(map['cyclist'] as Map<String, dynamic>),
      ridingRoute:
          RouteBlogModel.fromMap(map['ridingRoute'] as Map<String, dynamic>),
    );
  }
}

class Cyclist {
  final int userId;
  final String userName;
  final String profilePicture;
  Cyclist({
    required this.userId,
    required this.userName,
    required this.profilePicture,
  });

  factory Cyclist.fromMap(Map<String, dynamic> map) {
    return Cyclist(
      userId: map['userId'] as int,
      userName: map['userName'] as String,
      profilePicture: map['profilePicture'] as String,
    );
  }
}

class GroupRoutePaginationEntity {
  final List<GroupRouteEntity> groupRouteList;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;
  GroupRoutePaginationEntity({
    required this.groupRouteList,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  GroupRoutePaginationEntity copyWith({
    List<GroupRouteEntity>? groupRouteList,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPages,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return GroupRoutePaginationEntity(
      groupRouteList: groupRouteList ?? this.groupRouteList,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}

class GroupParticipantPaginationEntity {
  final List<Participant> participants;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final bool hasPreviousPage;
  final bool hasNextPage;
  GroupParticipantPaginationEntity({
    required this.participants,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  GroupParticipantPaginationEntity copyWith({
    List<Participant>? participants,
    int? totalCount,
    int? pageNumber,
    int? pageSize,
    int? totalPages,
    bool? hasPreviousPage,
    bool? hasNextPage,
  }) {
    return GroupParticipantPaginationEntity(
      participants: participants ?? this.participants,
      totalCount: totalCount ?? this.totalCount,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
