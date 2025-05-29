// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:Tracio/domain/user/entities/follow_entity.dart';
import 'package:Tracio/domain/user/entities/pagination_follow_data_entity.dart';

class FollowResponseEntity {
  final List<FollowEntity> follow;
  final PaginationFollowDataEntity pagination;
  FollowResponseEntity({
    required this.follow,
    required this.pagination,
  });

 


}
