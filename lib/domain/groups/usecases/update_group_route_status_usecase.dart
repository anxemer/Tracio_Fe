import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/groups/repositories/group_repository.dart';
import 'package:Tracio/service_locator.dart';

class UpdateGroupRouteStatusUsecaseParams {
  int groupId;
  int groupRouteId;
  String status;
  UpdateGroupRouteStatusUsecaseParams({
    required this.groupId,
    required this.groupRouteId,
    required this.status,
  });
}

class UpdateGroupRouteStatusUsecase
    extends Usecase<dynamic, UpdateGroupRouteStatusUsecaseParams> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<GroupRepository>()
        .updateGroupRouteStatus(params.groupId, params.groupId, params.status);
  }
}
