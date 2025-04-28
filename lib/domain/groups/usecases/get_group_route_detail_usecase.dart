// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/map/models/response/get_route_detail_rep.dart';
import 'package:tracio_fe/domain/groups/repositories/group_repository.dart';
import 'package:tracio_fe/service_locator.dart';

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
