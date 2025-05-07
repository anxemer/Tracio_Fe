import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/data/groups/models/request/post_group_req.dart';
import 'package:Tracio/domain/groups/repositories/group_repository.dart';
import 'package:Tracio/service_locator.dart';

class PostGroupUsecase extends Usecase<dynamic, PostGroupReq> {
  @override
  Future<Either<Failure, dynamic>> call(PostGroupReq params) async {
    return await sl<GroupRepository>().postGroup(params);
  }
}
