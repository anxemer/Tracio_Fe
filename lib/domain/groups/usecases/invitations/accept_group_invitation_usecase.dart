import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/groups/repositories/invitation_repository.dart';
import 'package:tracio_fe/service_locator.dart';

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
