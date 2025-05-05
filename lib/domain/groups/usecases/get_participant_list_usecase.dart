import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/groups/models/request/get_group_participant_req.dart';
import 'package:tracio_fe/data/groups/models/response/get_participant_list_rep.dart';
import 'package:tracio_fe/domain/groups/repositories/group_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetParticipantListUsecase
    extends Usecase<dynamic, GetGroupParticipantReq> {
  @override
  Future<Either<Failure, GetParticipantListRep>> call(params) async {
    return await sl<GroupRepository>()
        .getParticipantsByGroup(params.groupId, params.toQueryParam());
  }
}
