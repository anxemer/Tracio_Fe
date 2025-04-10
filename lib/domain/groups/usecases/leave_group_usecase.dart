import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/domain/groups/repositories/group_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class LeaveGroupUsecase extends Usecase<dynamic, int> {
  @override
  Future<Either<Failure, dynamic>> call(params) async {
    return await sl<GroupRepository>().leaveGroup(params);
  }
}
