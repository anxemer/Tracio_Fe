import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';

abstract class InvitationRepository {
  Future<Either<Failure, dynamic>> inviteUser(
      int groupId, List<int> inviteeIds);
  Future<Either<Failure, dynamic>> requestToJoinGroup(int groupId);
  Future<Either<Failure, dynamic>> responseInvitation(
      int invitationId, bool isApproved);
  Future<Either<Failure, dynamic>> responseToRequest(
      int invitationId, bool isApproved);
  // Future<Either<Failure, dynamic>> getInvitationList(
  //     int groupId, int page, int limit);
  // Future<Either<Failure, dynamic>> getUserRequestOfGroup(int groupId);
  // Future<Either<Failure, dynamic>> getMyInvitationAndRequest();
}
