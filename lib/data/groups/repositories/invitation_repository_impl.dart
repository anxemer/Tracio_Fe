import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/data/groups/source/invitation_api_service.dart';
import 'package:Tracio/domain/groups/repositories/invitation_repository.dart';
import 'package:Tracio/service_locator.dart';

class InvitationRepositoryImpl extends InvitationRepository {
  @override
  Future<Either<Failure, dynamic>> inviteUser(
      int groupId, List<int> inviteeIds) async {
    var returnedData =
        await sl<InvitationApiService>().inviteUser(groupId, inviteeIds);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> requestToJoinGroup(int groupId) async {
    var returnedData =
        await sl<InvitationApiService>().requestToJoinGroup(groupId);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> responseInvitation(
      int invitationId, bool isApproved) async {
    var returnedData = await sl<InvitationApiService>()
        .responseInvitation(invitationId, isApproved);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }

  @override
  Future<Either<Failure, dynamic>> responseToRequest(
      int invitationId, bool isApproved) async {
    var returnedData = await sl<InvitationApiServiceImpl>()
        .responseToRequest(invitationId, isApproved);
    return returnedData.fold((error) {
      return left(error);
    }, (data) {
      return right(data);
    });
  }
}
