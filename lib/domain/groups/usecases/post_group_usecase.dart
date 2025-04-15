import 'package:dartz/dartz.dart';
import 'package:tracio_fe/core/erorr/failure.dart';
import 'package:tracio_fe/core/usecase/usecase.dart';
import 'package:tracio_fe/data/groups/models/request/post_group_req.dart';
import 'package:tracio_fe/domain/groups/repositories/group_repository.dart';
import 'package:tracio_fe/service_locator.dart';

class PostGroupUsecase extends Usecase<dynamic, PostGroupReq> {
  @override
  Future<Either<Failure, dynamic>> call(PostGroupReq params) async {
    return await sl<GroupRepository>().postGroup(params);
  }
}
