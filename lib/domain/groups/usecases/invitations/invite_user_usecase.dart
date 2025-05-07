import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/groups/repositories/invitation_repository.dart';
import 'package:Tracio/service_locator.dart';

class InviteUserParams {
  final int groupId;
  final List<int> inviteeIds;

  InviteUserParams({
    required this.groupId,
    required this.inviteeIds,
  });
}

class InviteUserUsecase extends Usecase<dynamic, InviteUserParams> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<InvitationRepository>()
        .inviteUser(params.groupId, params.inviteeIds);
  }
}
