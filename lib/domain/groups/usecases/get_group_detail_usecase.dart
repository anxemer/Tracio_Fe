import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/groups/models/response/group_rep.dart';
import 'package:tracio_fe/domain/groups/repositories/group_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class GetGroupDetailUsecase extends Usecase<GroupResponseModel, int> {
  @override
  Future<Either<Failure, GroupResponseModel>> call(int params) async {
    return await sl<GroupRepository>().getGroupDetail(params);
  }
}
