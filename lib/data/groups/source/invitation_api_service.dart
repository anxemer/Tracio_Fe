import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tracio_fe/core/constants/api_url.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/network/dio_client.dart';
import 'package:tracio_fe/service_locator.dart';

abstract class InvitationApiService {
  Future<Either<Failure, dynamic>> inviteUser(
      int groupId, List<int> inviteeIds);
  Future<Either<Failure, dynamic>> requestToJoinGroup(int groupId);
  Future<Either<Failure, dynamic>> responseInvitation(
      int invitationId, bool isApproved);
  Future<Either<Failure, dynamic>> responseToRequest(
      int invitationId, bool isApproved);
  // Future<Either<Failure, dynamic>> getGroupInvitation(
  //     int invitationId, bool isApproved);
  // Future<Either<Failure, dynamic>> getUserRequestOfGroup(int groupId);
  // Future<Either<Failure, dynamic>> getMyInvitationAndRequest();
  // Future<Either<Failure, dynamic>> deleteMyInvitationAndRequest(
  //     int invitationId);
}

class InvitationApiServiceImpl extends InvitationApiService {
  @override
  Future<Either<Failure, dynamic>> inviteUser(
      int groupId, List<int> inviteeIds) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.urlSendInvitation(groupId).toString(), data: {
        'inviteeIds': inviteeIds,
      });

      if (response.statusCode == 201) {
        dynamic data = response.data['result'];
        return Right(data);
      } else if (response.statusCode == 403) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 403));
      } else if (response.statusCode == 409) {
        return Left(AuthorizationFailure(
            'You are already a member of this group.', 409));
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
  Future<Either<Failure, dynamic>> requestToJoinGroup(int groupId) async {
    try {
      var response = await sl<DioClient>()
          .post(ApiUrl.urlRequestToJoinGroup(groupId).toString());

      if (response.statusCode == 201) {
        dynamic data = response.data['result'];
        return Right(data);
      } else if (response.statusCode == 403) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 403));
      } else if (response.statusCode == 409) {
        return Left(AuthorizationFailure(
            'You are already a member of this group.', 409));
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
  Future<Either<Failure, dynamic>> responseInvitation(
      int invitationId, bool isApproved) async {
    try {
      var response = await sl<DioClient>().post(
          ApiUrl.urlAcceptInvitation(invitationId).toString(),
          data: isApproved);

      if (response.statusCode == 201) {
        dynamic data = response.data['result'];
        return Right(data);
      } else if (response.statusCode == 403) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 403));
      } else if (response.statusCode == 409) {
        return Left(AuthorizationFailure(
            'You are already a member of this group.', 409));
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
  Future<Either<Failure, dynamic>> responseToRequest(
      int invitationId, bool isApproved) async {
    try {
      var response = await sl<DioClient>().post(
          ApiUrl.urlAcceptInvitation(invitationId).toString(),
          data: isApproved);

      if (response.statusCode == 201) {
        dynamic data = response.data['result'];
        return Right(data);
      } else if (response.statusCode == 403) {
        return Left(AuthorizationFailure(
            'You do not have permission to perform this action.', 403));
      } else if (response.statusCode == 409) {
        return Left(AuthorizationFailure(
            'You are already a member of this group.', 409));
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
