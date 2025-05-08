import 'package:Tracio/domain/map/entities/route_media.dart';

class RouteMediaModel extends RouteMediaEntity {
  RouteMediaModel(
      {required super.mediaId,
      required super.mediaUrl,
      required super.location,
      required super.capturedAt,
      required super.uploadedAt});

  factory RouteMediaModel.fromMap(Map<String, dynamic> map) {
    return RouteMediaModel(
      mediaId: map['mediaId'] as int,
      mediaUrl: map['mediaUrl'] as String,
      location: map['location'] != null
          ? Location.fromMap(map['location'] as Map<String, dynamic>)
          : null,
      capturedAt: DateTime.parse(map['capturedAt'] as String),
      uploadedAt: DateTime.parse(map['uploadedAt'] as String),
    );
  }
}
