import 'package:Tracio/data/user/models/resolve_follow_request_req.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/user/repositories/user_profile_repository.dart';

import '../../../service_locator.dart';

class ResolveFollowUserUseCase extends Usecase<bool, ResolveFollowRequestReq> {
  @override
  Future<Either<Failure, bool>> call(ResolveFollowRequestReq params) async {
    return await sl<UserProfileRepository>().resolveRequest(params);
  }
}
