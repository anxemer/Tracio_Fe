import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/groups/models/request/post_group_route_req.dart';
import 'package:tracio_fe/data/groups/models/response/post_group_route_rep.dart';
import 'package:tracio_fe/domain/groups/repositories/group_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class PostGroupRouteParams extends Equatable {
  final int groupId;
  final PostGroupRouteReq request;

  const PostGroupRouteParams({
    required this.groupId,
    required this.request,
  });

  @override
  List<Object?> get props => [groupId, request];
}

class PostGroupRouteUsecase extends Usecase<dynamic, PostGroupRouteParams> {
  @override
  Future<Either<Failure, PostGroupRouteRep>> call(
      PostGroupRouteParams params) async {
    return await sl<GroupRepository>()
        .postGroupRoute(params.groupId, params.request);
  }
}
