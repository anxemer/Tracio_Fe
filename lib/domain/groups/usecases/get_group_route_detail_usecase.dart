// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/map/models/response/get_route_detail_rep.dart';
import 'package:Tracio/domain/groups/repositories/group_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetGroupRouteDetailUsecaseParams {
  int groupRouteId;
  int pageSize;
  int pageNumber;
  GetGroupRouteDetailUsecaseParams({
    required this.groupRouteId,
    this.pageSize = 1,
    this.pageNumber = 5,
  });
}

class GetGroupRouteDetailUsecase
    extends Usecase<dynamic, GetGroupRouteDetailUsecaseParams> {
  @override
  Future<Either<Failure, GetRouteDetailRep>> call(
      GetGroupRouteDetailUsecaseParams params) async {
    return await sl<GroupRepository>().getGroupRouteDetail(params.groupRouteId,
        pageNumber: params.pageNumber, pageSize: params.pageSize);
  }
}
