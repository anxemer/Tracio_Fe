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
import 'package:Tracio/data/groups/source/group_api_service.dart';
import 'package:Tracio/domain/groups/repositories/group_repository.dart';
import 'package:Tracio/service_locator.dart';

class GroupRepositoryImpl extends GroupRepository {
  @override
  Future<Either<Failure, dynamic>> postGroup(PostGroupReq request) async {
    var returnedData = await sl<GroupApiService>().createGroup(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, GroupResponseModel>> getGroupDetail(
      int groupId) async {
    var returnedData = await sl<GroupApiService>().getGroupDetail(groupId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, GetGroupListRep>> getGroups(
      GetGroupListReq request) async {
    var returnedData = await sl<GroupApiService>().getGroups(request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, PostGroupRouteRep>> postGroupRoute(
      int groupId, PostGroupRouteReq request) async {
    var returnedData =
        await sl<GroupApiService>().postGroupRoute(groupId, request);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, GetGroupRouteListRep>> getGroupRoutesByGroup(
      int groupId, Map<String, String> params) async {
    var returnedData =
        await sl<GroupApiService>().getGroupRoutesByGroup(groupId, params);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, GetParticipantListRep>> getParticipantsByGroup(
      int groupId, Map<String, String> params) async {
    var returnedData =
        await sl<GroupApiService>().getParticipantsByGroup(groupId, params);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> leaveGroup(int groupId) async {
    var returnedData = await sl<GroupApiService>().leaveGroup(groupId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, GetRouteDetailRep>> getGroupRouteDetail(
      int groupRouteId,
      {int pageNumber = 1,
      int pageSize = 5}) async {
    final params = {
      "pageNumber": pageNumber.toString(),
      "pageSize": pageSize.toString()
    };
    var returnedData =
        await sl<GroupApiService>().getGroupRouteDetail(groupRouteId, params);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, GetRouteDetailRep>> updateGroupRouteStatus(
      int groupRouteId, int groupId, String status) async {
    var returnedData = await sl<GroupApiService>()
        .updateStatusGroupRoute(groupRouteId, groupId, status);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }
}
