import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/groups/models/request/get_group_list_req.dart';
import 'package:Tracio/data/groups/models/request/post_group_req.dart';
import 'package:Tracio/data/groups/models/request/post_group_route_req.dart';
import 'package:Tracio/data/groups/models/response/get_group_list_rep.dart';
import 'package:Tracio/data/groups/models/response/get_group_route_list_rep.dart';
import 'package:Tracio/data/groups/models/response/get_participant_list_rep.dart';
import 'package:Tracio/data/map/models/response/get_route_detail_rep.dart';
import 'package:Tracio/data/groups/models/response/group_rep.dart';
import 'package:Tracio/data/groups/models/response/post_group_route_rep.dart';

abstract class GroupRepository {
  Future<Either<Failure, dynamic>> postGroup(PostGroupReq request);
  Future<Either<Failure, GetGroupListRep>> getGroups(GetGroupListReq request);
  Future<Either<Failure, GroupResponseModel>> getGroupDetail(int groupId);
  Future<Either<Failure, PostGroupRouteRep>> postGroupRoute(
      int groupId, PostGroupRouteReq request);
  Future<Either<Failure, GetGroupRouteListRep>> getGroupRoutesByGroup(
      int groupId, Map<String, String> params);
  Future<Either<Failure, GetParticipantListRep>> getParticipantsByGroup(
      int groupId, Map<String, String> params);
  Future<Either<Failure, dynamic>> leaveGroup(int groupId);
  Future<Either<Failure, GetRouteDetailRep>> getGroupRouteDetail(
      int groupRouteId,
      {int pageNumber = 1,
      int pageSize = 5});
  Future<Either<Failure, GetRouteDetailRep>> updateGroupRouteStatus(
      int groupRouteId, int groupId, String status);
}
