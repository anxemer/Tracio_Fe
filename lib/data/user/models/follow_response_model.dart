import 'package:Tracio/data/user/models/follow_model.dart';
import 'package:Tracio/data/user/models/pagination_follow_data_model.dart';
import 'package:Tracio/domain/user/entities/follow_response_entity.dart';

class FollowResponseModel extends FollowResponseEntity {
  FollowResponseModel({required super.follow, required super.pagination});

  factory FollowResponseModel.fromMap(Map<String, dynamic> map) {
    return FollowResponseModel(
      follow: map['items'] != null
          ? List<FollowModel>.from(map['items']
              .map((x) => FollowModel.fromJson(x as Map<String, dynamic>)))
          : [],
      pagination: PaginationFollowDataModel.fromMap(map),
    );
  }
}
