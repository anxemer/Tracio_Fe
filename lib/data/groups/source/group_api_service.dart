import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:Tracio/core/constants/api_url.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/network/dio_client.dart';
import 'package:Tracio/data/groups/models/request/get_group_list_req.dart';
import 'package:Tracio/data/groups/models/request/post_group_req.dart';
import 'package:Tracio/data/groups/models/request/post_group_route_req.dart';
import 'package:Tracio/data/groups/models/response/get_group_list_rep.dart';
import 'package:Tracio/data/groups/models/response/get_group_route_list_rep.dart';
import 'package:Tracio/data/groups/models/response/get_participant_list_rep.dart';
import 'package:Tracio/data/map/models/response/get_route_detail_rep.dart';
import 'package:Tracio/data/groups/models/response/group_rep.dart';
import 'package:Tracio/data/groups/models/response/post_group_route_rep.dart';
import 'package:Tracio/service_locator.dart';

abstract class GroupApiService {
  Future<Either<Failure, dynamic>> createGroup(PostGroupReq request);
  Future<Either<Failure, GetGroupListRep>> getGroups(GetGroupListReq request);
  Future<Either<Failure, GroupResponseModel>> getGroupDetail(int groupId);

  //TODO Reponse model
  Future<Either<Failure, dynamic>> updateGroup(
      int groupId, PostGroupReq request);
  Future<Either<Failure, dynamic>> deleteGroup(int groupId);
  Future<Either<Failure, PostGroupRouteRep>> postGroupRoute(
      int groupId, PostGroupRouteReq request);
  Future<Either<Failure, GetGroupRouteListRep>> getGroupRoutesByGroup(
      int groupId, Map<String, String> params);
  Future<Either<Failure, dynamic>> deleteGroupRoute(
      int groupId, int groupRouteId);
  Future<Either<Failure, dynamic>> updateGroupRoute(
      int groupId, int groupRouteId, PostGroupRouteReq request);
  Future<Either<Failure, GetParticipantListRep>> getParticipantsByGroup(
      int groupId, Map<String, String> params);
  Future<Either<Failure, dynamic>> kickUser(int groupId, int targetUserId);
  Future<Either<Failure, dynamic>> leaveGroup(int groupId);
  Future<Either<Failure, dynamic>> assignRole(
      int groupId, int targetUserId, bool isOrganizer);

  Future<Either<Failure, dynamic>> getGroupRouteDetail(int groupRouteId,
      [Map<String, String>? params]);
}

class GroupApiServiceImpl extends GroupApiService {
  @override
  Future<Either<Failure, dynamic>> createGroup(PostGroupReq request) async {
    try {
      FormData formData = await request.toFormData();
      var response = await sl<DioClient>()
          .post(ApiUrl.postGroup, data: formData, isMultipart: true);

      if (response.statusCode == 201) {
        var groupId = response.data["result"]["groupId"];
        return right(groupId);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, GroupResponseModel>> getGroupDetail(
      int groupId) async {
    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlGetGroupDetail(groupId).toString());

      if (response.statusCode == 200) {
        GroupResponseModel data =
            GroupResponseModel.fromMap(response.data['result']);
        return Right(data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(
          ExceptionFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, GetGroupListRep>> getGroups(
      GetGroupListReq request) async {
    try {
      var response = await sl<DioClient>()
          .get(ApiUrl.urlGetGroupList(request.toQueryParams()).toString());

      if (response.statusCode == 200) {
        GetGroupListRep data = GetGroupListRep.fromMap(response.data['result']);
        return Right(data);
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, GetGroupRouteListRep>> getGroupRoutesByGroup(
      int groupId, Map<String, String> params) async {
    try {
      var response = await sl<DioClient>().get(ApiUrl.urlGetGroupRoute(groupId)
          .replace(queryParameters: params)
          .toString());

      if (response.statusCode == 200) {
        GetGroupRouteListRep data =
            GetGroupRouteListRep.fromMap(response.data['result']);
        return Right(data);
      } else if (response.statusCode == 400) {
        return Left(AuthorizationFailure(
            'You do not have permission to access this resource.', 400));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(
          ExceptionFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, GetParticipantListRep>> getParticipantsByGroup(
      int groupId, Map<String, String> params) async {
    try {
      var response = await sl<DioClient>().get(
          ApiUrl.urlGetParticipants(groupId)
              .replace(queryParameters: params)
              .toString());

      if (response.statusCode == 200) {
        GetParticipantListRep data =
            GetParticipantListRep.fromMap(response.data['result']);
        return Right(data);
      } else if (response.statusCode == 400) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 400));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(
          ExceptionFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PostGroupRouteRep>> postGroupRoute(
      int groupId, PostGroupRouteReq request) async {
    try {
      var uri = ApiUrl.urlPostGroupRoute(groupId);
      var response =
          await sl<DioClient>().post(uri.toString(), data: request.toMap());

      if (response.statusCode == 201) {
        var groupResponse = PostGroupRouteRep.fromMap(response.data["result"]);
        return right(groupResponse);
      } else if (response.statusCode == 400) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 400));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> assignRole(
      int groupId, int targetUserId, bool isOrganizer) async {
    try {
      var response = await sl<DioClient>().put(
          ApiUrl.urlAssignRoleGroupOwner(groupId, targetUserId).toString(),
          data: isOrganizer);

      if (response.statusCode == 200) {
        dynamic data = response.data['result'];
        return Right(data);
      } else if (response.statusCode == 400) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 400));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(
          ExceptionFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteGroup(int groupId) async {
    try {
      var response =
          await sl<DioClient>().delete("${ApiUrl.urlDeleteGroup}/$groupId");

      if (response.statusCode == 200) {
        dynamic data = response.data['result'];
        return Right(data);
      } else if (response.statusCode == 400) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 400));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(
          ExceptionFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> deleteGroupRoute(
      int groupId, int groupRouteId) async {
    try {
      var response = await sl<DioClient>().delete(
        ApiUrl.urlDeleteGroupRoute(groupId, groupRouteId).toString(),
      );

      if (response.statusCode == 200) {
        dynamic data = response.data['result'];
        return Right(data);
      } else if (response.statusCode == 400) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 400));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(
          ExceptionFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> kickUser(
      int groupId, int targetUserId) async {
    try {
      var response = await sl<DioClient>().delete(
          ApiUrl.urlRemoveParticipant(groupId, targetUserId).toString());

      if (response.statusCode == 200) {
        dynamic data = response.data['result'];
        return Right(data);
      } else if (response.statusCode == 400) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 400));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(
          ExceptionFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> leaveGroup(int groupId) async {
    try {
      var response = await sl<DioClient>()
          .delete(ApiUrl.urlLeaveGroup(groupId).toString());

      if (response == null) {
        return Right(null);
      }
      if (response.statusCode == 404) {
        return Left(ExceptionFailure(
            'Group not found. You may have already left the group.'));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(
          ExceptionFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> updateGroup(
      int groupId, PostGroupReq request) async {
    try {
      FormData formData = await request.toFormData();
      var response = await sl<DioClient>().put(
        ApiUrl.urlUpdateGroup,
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      if (response.statusCode == 200) {
        var groupId = response.data["result"]["groupId"];
        return right(groupId);
      } else if (response.statusCode == 400) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 400));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> updateGroupRoute(
      int groupId, int groupRouteId, PostGroupRouteReq request) async {
    try {
      var uri = ApiUrl.urlUpdateGroupRoute(groupId, groupRouteId);
      var response =
          await sl<DioClient>().put(uri.toString(), data: request.toMap());

      if (response.statusCode == 200) {
        var groupResponse = PostGroupRouteRep.fromMap(response.data["result"]);
        return right(groupResponse);
      } else if (response.statusCode == 400) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 400));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(ExceptionFailure('An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, GetRouteDetailRep>> getGroupRouteDetail(
      int groupRouteId,
      [Map<String, String>? params]) async {
    try {
      var uri = ApiUrl.urlGetGroupRouteDetail(groupRouteId, params);
      var response = await sl<DioClient>().get(uri.toString());

      if (response.statusCode == 200) {
        return right(GetRouteDetailRep.fromMap(response.data['result']));
      } else if (response.statusCode == 400) {
        return Left(
            ExceptionFailure(response.data['message'] ?? 'Something wrong!!'));
      } else if (response.statusCode == 404) {
        return Left(ExceptionFailure(response.data['message'] ?? 'Not Found'));
      } else {
        return left(ExceptionFailure('Error: ${response.statusCode}'));
      }
    } on DioException catch (e) {
      return Left(ExceptionFailure(
          e.response?.data ?? e.message ?? 'An error occurred'));
    } catch (e) {
      return left(
          ExceptionFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
