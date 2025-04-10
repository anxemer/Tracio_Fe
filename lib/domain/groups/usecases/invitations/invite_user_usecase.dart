import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/groups/repositories/invitation_repository.dart';
import 'package:tracio_fe/service_locator.dart';

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
