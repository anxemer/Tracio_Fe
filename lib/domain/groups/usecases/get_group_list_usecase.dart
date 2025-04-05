import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/groups/models/request/get_group_list_req.dart';
import 'package:tracio_fe/data/groups/models/response/get_group_list_rep.dart';
import 'package:tracio_fe/domain/groups/repositories/group_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetGroupListUsecase extends Usecase<dynamic, GetGroupListReq> {
  @override
  Future<Either<Failure, GetGroupListRep>> call(GetGroupListReq params) async {
    return await sl<GroupRepository>().getGroups(params);
  }
}
