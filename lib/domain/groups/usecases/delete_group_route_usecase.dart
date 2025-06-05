import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/groups/repositories/group_repository.dart';
import 'package:Tracio/service_locator.dart';

class DeleteGroupRouteUsecaseParams {
  final int groupId;
  final int groupRouteId;
  DeleteGroupRouteUsecaseParams({
    required this.groupId,
    required this.groupRouteId,
  });
}

class DeleteGroupRouteUsecase
    extends Usecase<dynamic, DeleteGroupRouteUsecaseParams> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<GroupRepository>()
        .deleteGroupRoute(params.groupId, params.groupRouteId);
  }
}
