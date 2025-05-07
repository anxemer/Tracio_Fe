import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/groups/repositories/invitation_repository.dart';
import 'package:Tracio/service_locator.dart';

class AcceptGroupInvitationParam {
  final int invitationId;
  final bool isApproved;

  AcceptGroupInvitationParam({
    required this.invitationId,
    required this.isApproved,
  });
}

class AcceptGroupInvitationUsecase
    extends Usecase<dynamic, AcceptGroupInvitationParam> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<InvitationRepository>()
        .responseInvitation(params.invitationId, params.isApproved);
  }
}
