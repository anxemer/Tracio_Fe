import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/data/groups/models/request/get_group_list_req.dart';
import 'package:tracio_fe/data/groups/models/request/post_group_req.dart';
import 'package:tracio_fe/data/groups/models/response/get_group_list_rep.dart';
import 'package:tracio_fe/data/groups/models/response/group_rep.dart';

abstract class GroupRepository {
  Future<Either<Failure, dynamic>> postGroup(PostGroupReq request);
  Future<Either<Failure, GetGroupListRep>> getGroups(GetGroupListReq request);
  Future<Either<Failure, GroupResponseModel>> getGroupDetail(int groupId);
}
