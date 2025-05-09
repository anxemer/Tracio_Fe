import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/groups/repositories/invitation_repository.dart';
import 'package:Tracio/service_locator.dart';

class ResponseJoinGroupRequestParam {
  final int invitationId;
  final bool isApproved;

  ResponseJoinGroupRequestParam({
    required this.invitationId,
    required this.isApproved,
  });
}

class ResponseJoinGroupRequestUsecase
    extends Usecase<dynamic, ResponseJoinGroupRequestParam> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<InvitationRepository>()
        .responseInvitation(params.invitationId, params.isApproved);
  }
}
