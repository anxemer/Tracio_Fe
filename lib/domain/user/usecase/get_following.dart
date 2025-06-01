import 'package:Tracio/domain/user/entities/follow_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:Tracio/core/erorr/failure.dart';
import 'package:Tracio/core/usecase/usecase.dart';
import 'package:Tracio/domain/user/repositories/user_profile_repository.dart';

import '../../../data/user/models/get_follow_req.dart';
import '../../../service_locator.dart';
import '../entities/follow_response_entity.dart';

class GetFollowingUseCase extends Usecase<FollowResponseEntity, GetFollowReq> {
  @override
  Future<Either<Failure, FollowResponseEntity>> call(params) async {
    return await sl<UserProfileRepository>().getFollowing(params);
  }
}
