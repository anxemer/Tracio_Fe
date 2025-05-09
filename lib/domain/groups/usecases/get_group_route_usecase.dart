import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/groups/models/request/get_group_route_req.dart';
import 'package:Tracio/data/groups/models/response/get_group_route_list_rep.dart';
import 'package:Tracio/domain/groups/repositories/group_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetGroupRouteUsecase extends Usecase<dynamic, GetGroupRouteReq> {
  @override
  Future<Either<Failure, GetGroupRouteListRep>> call(params) async {
    return await sl<GroupRepository>()
        .getGroupRoutesByGroup(params.groupId, params.toQueryParam());
  }
}
