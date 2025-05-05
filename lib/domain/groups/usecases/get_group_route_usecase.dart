import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/groups/models/request/get_group_route_req.dart';
import 'package:tracio_fe/data/groups/models/response/get_group_route_list_rep.dart';
import 'package:tracio_fe/domain/groups/repositories/group_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetGroupRouteUsecase extends Usecase<dynamic, GetGroupRouteReq> {
  @override
  Future<Either<Failure, GetGroupRouteListRep>> call(params) async {
    return await sl<GroupRepository>()
        .getGroupRoutesByGroup(params.groupId, params.toQueryParam());
  }
}
