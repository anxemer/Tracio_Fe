import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/groups/models/response/group_rep.dart';
import 'package:Tracio/domain/groups/repositories/group_repository.dart';
import 'package:Tracio/service_locator.dart';

class GetGroupDetailUsecase extends Usecase<GroupResponseModel, int> {
  @override
  Future<Either<Failure, GroupResponseModel>> call(int params) async {
    return await sl<GroupRepository>().getGroupDetail(params);
  }
}
